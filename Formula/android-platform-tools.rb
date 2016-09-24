class AndroidPlatformTools < Formula
  desc "Tools for the Android SDK"
  homepage "https://developer.android.com/sdk"
  # the url is from:
  # https://dl.google.com/android/repository/repository-12.xml
  url "https://dl.google.com/android/repository/platform-tools_r24-macosx.zip"
  version "24"
  sha256 "5eb758fe3ddddd8e522c17244bbcb886f399529855bad60c8ba14711dc5a8a12"

  bottle :unneeded

  depends_on :macos => :mountain_lion

  conflicts_with "android-sdk",
    :because => "the Android Platform-tools are part of the Android SDK"

  def install
    bin.install "adb", "fastboot"
  end
end
