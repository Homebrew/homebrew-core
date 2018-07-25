class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/phonegap/ios-deploy"
  url "https://github.com/phonegap/ios-deploy/archive/1.9.3.tar.gz"
  sha256 "9ef7430d20a777cd2916ab9d6aac849de11b349e85cf80048c95eca47d026e6c"
  head "https://github.com/phonegap/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34d44f6f2252037c01251e1ea0b19ac80eed08731547a0cf877b58886b8a24aa" => :high_sierra
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
