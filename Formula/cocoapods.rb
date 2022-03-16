class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.3.tar.gz"
  sha256 "91d31754611520529b101ee57a059c5caadcd7ddb3c5b3b1065edc0ef5c43372"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "001989d76642dcce6db769abfc15d637a7f3cc45bda2fc982de474494fc8cc31"
    sha256 cellar: :any,                 arm64_big_sur:  "d6da560b3cbe34caf25925616ee48c11bf3ceb3b7f7773859862d5c3785876c8"
    sha256                               monterey:       "5723991d3a4780ee8d9469742267a6bb0c96862498044f5ba0ffc69a23b81393"
    sha256                               big_sur:        "69e1b8d58e10aba88e7ef86c7334dfcea72801c080c84fc0172d14c0ac47255f"
    sha256                               catalina:       "deaa62a6366d2d1aadc10d5159fcf5e59146c1f156db6fa49059a457731c402f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8e5eeb99f91b86083c5e5201e300da729075e8736dc28fcf771a9836054acc"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" if Hardware::CPU.arm?

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
