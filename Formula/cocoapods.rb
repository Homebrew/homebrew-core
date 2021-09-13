class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.2.tar.gz"
  sha256 "c1f7454a93e334484cc15ec8a88ded4080bf5e39df2b0dff729a2e77044dc3df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5f4770eb033db211cb78afa026f45aec82a32cc62b6823e4d72c024a1357471b"
    sha256                               big_sur:       "def97dc0be0678114423091c819134ee289594fdd21cfeccb11ea5f95918dc8c"
    sha256                               catalina:      "c9d588214f088add95aaa6a520e5de0ad9b7cc1fb15536a350b4b3ca24ad2c36"
    sha256 cellar: :any,                 mojave:        "cded84974af0757f6c9ffdcf5a61f448e7d1eae9c6168c493ad6b3af312ca118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05a7db53b1a4cd397bb84695f41267a8ab8d48bf7305259e2a4cfdcd405d54bf"
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
