/*《电子相册浏览器》
   优点：节省内存、代码简单、容易操作。
   缺点：会增加对硬件的要求。
 */
//  Created by 周双建 on 16/1/12.
//  Copyright © 2016年 周双建. All rights reserved.
//
/***************************************************************/
#import "ViewController.h"

@interface ViewController (){
    // 创建一个全局变量用于记录操作的次数
    int  OperateCount;
    // 标点控制
    UIPageControl * PageControl;
}
// 本工程的主角是一个UIImageView
@property(nonatomic,strong) UIImageView * ElectronAlbumBrowserImageV;
// 创建一个用于存放图片的数组（利用了数组的有序性）。
@property(nonatomic,strong) NSArray * ElectronAlbumBrowserDataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置我们的标题
    [self makeNav];
    //我们初始化几个对象
    // 主角
    self.ElectronAlbumBrowserImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _ElectronAlbumBrowserImageV.image = [UIImage imageNamed:@"c12f5835c6a40950dc6b904c69ce3338.jpg"];
    // 主角的标记
    _ElectronAlbumBrowserImageV.tag = 0;
    // 我们要打开交互
    _ElectronAlbumBrowserImageV.userInteractionEnabled = YES;
    // 是否添加点击
    [self TapClick];
    // 主角的登上舞台
    [self.view addSubview:_ElectronAlbumBrowserImageV];
    // 初始化数据数组
    self.ElectronAlbumBrowserDataArray = [NSArray array];
    // 进行网络请求数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
        // 模拟网络请求
        _ElectronAlbumBrowserDataArray = @[[UIImage imageNamed:@"0061497f835549c792559776053fdbec.jpg"],[UIImage imageNamed:@"16954bea2e61e208589b84984f400f20.jpg"],[UIImage imageNamed:@"616743c4dfe3a606ae80674987f529e9.jpg"],[UIImage imageNamed:@"9790072c19f6d7f31ad9cfb6551d6a7d.jpg"],[UIImage imageNamed:@"c12f5835c6a40950dc6b904c69ce3338.jpg"],[UIImage imageNamed:@"c9ddcacbd189e1cfec4d1310e4383438.jpg"]];
            PageControl.numberOfPages =_ElectronAlbumBrowserDataArray.count;

    });
    // 创建标点控制器
    self->PageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.view.bounds.size.height-30, self.view.bounds.size.width-200, 20)];
    PageControl.currentPage = 0;
    PageControl.pageIndicatorTintColor = [UIColor yellowColor];
    PageControl.currentPageIndicatorTintColor = [UIColor redColor];
   [self.view addSubview:PageControl];
    // 关键的一个配角(右)
    UISwipeGestureRecognizer * Right_Swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipType:)];
    Right_Swip.direction = UISwipeGestureRecognizerDirectionRight;
    // 关键的二个配角(左)
    UISwipeGestureRecognizer * Left_Swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipType:)];
    Left_Swip.direction = UISwipeGestureRecognizerDirectionLeft;
    // 配角登录舞台
    [self.view addGestureRecognizer:Right_Swip];
    [self.view addGestureRecognizer:Left_Swip];
    // Do any additional setup after loading the view, typically from a nib.
}
// 实现配角的功能
-(void)SwipType:(UISwipeGestureRecognizer*)Type_Swip{
    // 进行手势的判断
    if (Type_Swip.direction == UISwipeGestureRecognizerDirectionLeft ) {
        OperateCount++;
        [self ElectronAlbumBrowser:NO indexPath:OperateCount];
        
    }else if (Type_Swip.direction == UISwipeGestureRecognizerDirectionRight){
        OperateCount--;
        [self ElectronAlbumBrowser:YES indexPath:OperateCount];
    }else{
        return;
    }
}
// 核心部分
-(void)ElectronAlbumBrowser:(BOOL)Yes_No indexPath:(int)index{
    // 核心场景 CATransaction 、CATransition（看好了，不要弄错了）。
     CATransition *transition=[[CATransition alloc]init];
     //2.设置动画类型,
    transition.type=[self Stochastic];
    // 我们要设置动画的时间
    transition.duration = 1;
    // 动画的其实位置（值越小，开始越靠右）
    transition.startProgress = 0.1;
    // 动画结束的位置 (要和上面的 startProgress +  endProgress = 1 )
    transition.endProgress = 0.9;
    // 一个公共的对象
    /* 
     filter  是图像的话，将影响动画的效果，使其变为 淡入淡出的形式。
     */
    transition.filter = nil;
    // 我们设置动画入场的方向
    /*
     
    Common transition subtypes的可用类型如下.
    // 右
    CA_EXTERN NSString * const kCATransitionFromRight
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     
    // 左
    CA_EXTERN NSString * const kCATransitionFromLeft
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     
    //上
    CA_EXTERN NSString * const kCATransitionFromTop
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     
    //下
    CA_EXTERN NSString * const kCATransitionFromBottom
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
     
     
     
    __OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
    这是支持的最低版本。
     
      */
    if (Yes_No) {
        transition.subtype = kCATransitionFromLeft;
    }else{
        transition.subtype = kCATransitionFromRight;
    }
    // 信息数字的优化
    int  ATMS_Count = OperateCount%_ElectronAlbumBrowserDataArray.count;
    PageControl.currentPage = ATMS_Count;
    // 添加美丽画面
    _ElectronAlbumBrowserImageV.image = _ElectronAlbumBrowserDataArray[ATMS_Count];
    //绑定标记
    _ElectronAlbumBrowserImageV.tag = ATMS_Count;
    // 设置到动画载体上
    [_ElectronAlbumBrowserImageV.layer addAnimation:transition forKey:@"ZSJ_ImageV"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)makeNav{
    UIView * Nav_View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    Nav_View.backgroundColor = [UIColor whiteColor];
    UILabel * Title_Label = [[UILabel alloc]initWithFrame:CGRectMake(Nav_View.frame.size.width * 0.5 -100, 20, 200, 44)];
    Title_Label.text = @"成功QQ吧提供---图片浏览器";
    Title_Label.textColor = [UIColor blackColor];
    Title_Label.font = [UIFont italicSystemFontOfSize:15];
    Title_Label.textAlignment = NSTextAlignmentCenter;
    [Nav_View addSubview:Title_Label];
    UIView * Line_View = [[UIView alloc]initWithFrame:CGRectMake(0, 63, self.view.bounds.size.width, 1)];
    Line_View.backgroundColor = [UIColor lightGrayColor];
    [Nav_View addSubview:Line_View];
    [self.view addSubview:Nav_View];
}
// 随机获取动画类型
-(NSString*)Stochastic{
    int  TimeCount =  1;
    switch (TimeCount) {
        case 0:
            // 方盒子
             return @"cube";
            break;
        case 1:
            // 淡出
            return @"movein";
            break;
        case 2:
            // 垂直翻转
            return @"oglFlip";
            break;
        case 3:
            // 抽去
            return @"suckEffect";
            break;
        case 4:
            // 水波
            return @"rippleEffect";
            break;
        case 5:
            // 上翻页
            return @"pageCurl";
            break;
        case 6:
            //下翻页
            return @"pageUnCurl";
            break;
        case 7:
            // 相机开
            return @"cameralIrisHollowOpen";
            break;
        case 8:
            // 相机关
            return @"cameraIrisHollowClose";
            break;
        case 9:
            return @"fade";
            break;
            
        default:
            return @"";
            break;
    }

}
// 是否要有点击
-(void)TapClick{
    UITapGestureRecognizer * Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapG:)];
    [_ElectronAlbumBrowserImageV addGestureRecognizer:Tap];
}
// 点击的是哪个
-(void)TapG:(UITapGestureRecognizer*)Chick_Tap{
    NSLog(@"我点击的是哪个：%ld",Chick_Tap.view.tag);
}
@end
