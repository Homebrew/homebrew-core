class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.10.0.tar.gz"
  sha256 "d44c70047020ea114ca950df6d4499b1f86e5e7bbd3536a46f6fa3e32f1df21e"
  license "MIT"

  bottle do
    sha256 "e134955d0501635a62e16c9c9b10e01c5f8b9e0ffdeee3d7b778db5845bd88a1" => :catalina
    sha256 "9977145a066bf2545f5fe3d1ddd41f0360c7efe46523087d56cf06ac305eb069" => :mojave
    sha256 "783448183d3bb63dc46c8148fe1f3b783b705bfda763fb6f6237760e30b94ff6" => :high_sierra
  end

  depends_on "pkg-config" => :build

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
