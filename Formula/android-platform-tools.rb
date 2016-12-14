class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/sdk"
  version "25"

  # the url is from:
  # https://dl.google.com/android/repository/repository-12.xml
  if OS.mac?
    url "https://dl.google.com/android/repository/platform-tools_r25-macosx.zip"
    sha256 "33030a8ecbc419fcd80b01d274e7869417524b1f06b005a0f6d9a7f69e95ebec"
  elsif OS.linux?
    url "https://dl.google.com/android/repository/platform-tools_r25-linux.zip"
    sha256 "8ce9dcb1bd2df125347f70657f99a77996090d686ec42d1397ce050cc13f7262"
  end

  bottle :unneeded

  depends_on :macos => :mountain_lion

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end

  test do
    system bin/"fastboot --version"
    system bin/"adb version"
  end
end
