class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/phonegap/ios-deploy/archive/1.9.1.tar.gz"
  sha256 "2d778e01b286a5675929c7ffd6b41e56ec5d58a3d25398fe6210a2b119a33a5d"
  head "https://github.com/phonegap/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1743903546fffb2a99cc3e37545ad73bed72847acd85a841efc8c4f81cd60bfb" => :sierra
    sha256 "d531065c48ff67cbd8ebcd0c5d0cf8d09435795295fd70d92ca5f04c178b8afc" => :el_capitan
    sha256 "6531b11ce76cbee417fe309c8348a3330174a5b272deec04e0d62e5d31d4366d" => :yosemite
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build"

    xcodebuild "test", "-scheme", "ios-deploy-tests", "-configuration", "Release", "SYMROOT=build"

    bin.install "build/Release/ios-deploy"
    include.install "build/Release/libios_deploy.h"
    lib.install "build/Release/libios-deploy.a"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end
