class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/phonegap/ios-deploy/archive/1.8.6.tar.gz"
  sha256 "e0c20294e43bc231292cc9f3172113e0da8f728b1ed988fb4fe883ae99b20056"
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
