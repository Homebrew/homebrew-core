class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/phonegap/ios-deploy/archive/1.8.7.tar.gz"
  sha256 "01048c98221fa11fbd1e4af1798c15ba5b8bf8ef17f07572650410f5dfa9f1e2"
  head "https://github.com/phonegap/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11c48e627e609830c57c230b38716318db165c69cc1a32c8a777e9076334ee37" => :el_capitan
    sha256 "183f932cc95c3bbfd9fba037761432a01dd85b861aec6cf4b0c7ca9bd7f8485e" => :yosemite
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
