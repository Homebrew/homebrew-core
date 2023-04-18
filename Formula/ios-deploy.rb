class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  stable do
    url "https://github.com/ios-control/ios-deploy/archive/1.12.1.tar.gz"
    sha256 "635cc36b027ec36cd9f5ebd4136f0e1274caa60049c1f6e4fd15d45d7bef5bc3"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70ee426a92f9c051982e92df8d46723cc89b8fecb7d696b99720c13d3b98007b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da920d213de78388f4dfeb2c87e8c93f188aaa3acc506eef86ce3e6762dec43a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d047f57995db0f9c5897455967d85c8ddd8413b853ffda376467c04a8d47960"
    sha256 cellar: :any_skip_relocation, ventura:        "96daffa7e01337c33d71ca1afdba51b34e100327d171a4c08a0b390b404237a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9b8206addd8b1d07a8b50fa2a88c9c9ebf8697a9fefa21835336019193ca9102"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea7341be8f08529d848ffe7fe7bfb75cbbb42e0d7d017667c704de1f0a12a4e0"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    xcodebuild "test",
               "-scheme", "ios-deploy-tests",
               "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    bin.install "build/Release/ios-deploy"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end
