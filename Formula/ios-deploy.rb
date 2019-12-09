class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.10.0.tar.gz"
  sha256 "619176b0a78f631be169970a5afc9ec94b206d48ec7cb367bb5bf9d56b098290"
  head "https://github.com/phonegap/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43b17fb8423e24b280873044eebe7100bb0788f7fca80e4e48062a73f6183de9" => :mojave
    sha256 "92be61884aeaa78e0571ec9764e841831c513733319c5b42439bda26640877c6" => :high_sierra
    sha256 "8e46be474d63299f12cef533429a4c77a52d5a4872b79e29c47acf47d673d2ef" => :sierra
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
