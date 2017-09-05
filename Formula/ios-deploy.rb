class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/phonegap/ios-deploy/archive/1.9.2.tar.gz"
  sha256 "fbf9a60ba38cb15afc9a35a39c44d1e536a57d0f6c26126385792793e7d9d43a"
  head "https://github.com/phonegap/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a37ba013cacf7f27f31e4637464313135b5813c323b79796cef8bec77b5304c5" => :sierra
    sha256 "c8d610c15df4311f02670d578629dbea1f8ba31cdea6bdb7e36f1ead75e48be5" => :el_capitan
    sha256 "a4849694da9a396a14a6e2f67418da862363d2c2f14a514eeab32d79c320587e" => :yosemite
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
