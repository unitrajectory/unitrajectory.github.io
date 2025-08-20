@echo off
setlocal enabledelayedexpansion

:: 设置FFmpeg路径和视频信息
set "ffmpeg_path=D:\AAAI\ffmpeg-2025-07-10-git-82aeee3c19-full_build\bin\ffmpeg.exe"
set "video_path=D:\AAAI\p3_for_framework_larger_points\camera_control\zoom_out\trace.mp4"
set "output_dir=D:\AAAI\p3_for_framework_larger_points\camera_control\zoom_out"

:: 创建输出帧的临时目录
set "temp_frames_dir=%output_dir%\temp_frames"
mkdir "%temp_frames_dir%" 2>nul

:: 第一步：使用指定路径的ffmpeg无损提取所有帧
echo 正在提取所有帧...
"%ffmpeg_path%" -i "%video_path%" -vsync 0 -q:v 0 "%temp_frames_dir%\frame_%%06d.png"

:: 第二步：按指定索引（5 27 54 81）提取目标帧
echo 正在提取指定帧...
set "target_indices=0 20 40 60 80"
for %%i in (%target_indices%) do (
    set /a "frame_num=%%i + 1"
    call :pad_with_zeros !frame_num! 6 padded_num
    copy "%temp_frames_dir%\frame_!padded_num!.png" "%output_dir%\frame2_%%i.png" >nul
    echo 已提取帧：frame1_%%i.png
)

:: 清理临时文件
rmdir /s /q "%temp_frames_dir%" >nul 2>nul

echo 提取完成！目标帧已保存至：%output_dir%
endlocal
exit /b

:: 辅助函数：将数字补零至指定长度
:pad_with_zeros
set "num=%1"
set "length=%2"
set "padded=0000000000%num%"
set "%3=!padded:~-%length%!"
exit /b