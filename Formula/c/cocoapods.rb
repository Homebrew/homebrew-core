class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.16.2.tar.gz"
  sha256 "3067f21a0025aedb5869c7080b6c4b3fa55d397b94fadc8c3037a28a6cee274c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0caae17dd3fbb66ff2ddfd2f0b729841b2b79150674f8123be0c4e67ba2810"
    sha256 cellar: :any,                 arm64_sequoia: "c0bd1f8e2bdb31e76d8919d8c5181c5ffacab9aa03b9be9cd77c4fcfdd2f0527"
    sha256 cellar: :any,                 arm64_sonoma:  "46d7033d09663c83d43346815b67d4abac9c68b2cff38a7a0eaf55fcf459f56d"
    sha256 cellar: :any,                 arm64_ventura: "95765343247a0af19d81ab36c3ab8e379e7729f688da64ae723f49c7deba34d7"
    sha256 cellar: :any,                 sonoma:        "783c64ac3c486bae33e11edf68a56380245d3fe783e1c60e2548a08e05adedef"
    sha256 cellar: :any,                 ventura:       "b1358f53cd22a76793b935b5b3d4fa384cbe292d85d6a02fccf7232ea038890d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9adde4afac9cbde48d0356f24619557eb25ff14ccdf26c7038c76c783d88c676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0ed8f654a355942ff4df4236ad181fa474aad5188cf2de73e6412b9df098b1"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"
  uses_from_macos "libffi"

  conflicts_with cask: "cocoapods-app", because: "both install `pod` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pod", "list"
  end
end
