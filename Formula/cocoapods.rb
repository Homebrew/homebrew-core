class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.10.1.tar.gz"
  sha256 "7629705179e4bfd894bebe4ed62c28d1cc539103f6d1924f4c8127f46cbd13e1"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bf7b573944dfb6dee095e847102eb5595cafc69e56bd3e0f19e2bbe77b0b3e49"
    sha256               big_sur:       "49e9b04847f8a3a667b3fa53cc1f66b001e461108c90704abe2981e7a560b0c7"
    sha256               catalina:      "93a20a23596270d968a7b76f40f6a092218c75f53546ac8f0c84002df8d10974"
    sha256 cellar: :any, mojave:        "d573ae11f98d5313564180a02c158173df17222cf81e7be1b8a370373e3e48fb"
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
