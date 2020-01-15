class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.10.0.tar.gz"
  sha256 "619176b0a78f631be169970a5afc9ec94b206d48ec7cb367bb5bf9d56b098290"
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a368bb1c001f48f1c7354cdeb01fe67a4173489f9eadf6eab5b699caa5bacd7e" => :catalina
    sha256 "6cfe843e5188f80b8c058da78acd1bab5260aea5fd4aa0a8685b8ff2e030aabc" => :mojave
    sha256 "e4065110d50914cb2f1d6ef564f47a29ad3accd155b76e2a722cb0e40ed6764b" => :high_sierra
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
