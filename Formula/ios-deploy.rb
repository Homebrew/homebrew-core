class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/phonegap/ios-deploy/archive/1.8.7.tar.gz"
  sha256 "01048c98221fa11fbd1e4af1798c15ba5b8bf8ef17f07572650410f5dfa9f1e2"
  head "https://github.com/phonegap/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea5cb3c16f47a2068c60eeee1d35a376b078c5364f0795b4b8a50824854827b4" => :el_capitan
    sha256 "a72a11ea37a7e5d3a866672625ada52a53c05c6fff665c06abc2cc35e69be129" => :yosemite
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
