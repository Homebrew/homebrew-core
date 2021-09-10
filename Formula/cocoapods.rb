class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.0.tar.gz"
  sha256 "4f494e7651cdf1a7afae6117fb1ed33c919471d7bc3b7575a68d5c316faf567c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "76747ed81b475d1f1ff107bc3b5c4d40428eae3de1fed1013dd4aa88d28d9f60"
    sha256                               big_sur:       "e28afda81704ecd7620c3690a664c01477294ee724fefc8e98d2842ffdb87e9e"
    sha256                               catalina:      "4743bfd539f5cf8440669c6aaa64da2c45ff1343f8953229d5156e7f1f5eb96b"
    sha256 cellar: :any,                 mojave:        "0c11497ef552668f9d9e602e8031413f4513ba752e14a45782acfe0e72c12cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd089829f55aa89c6cb27584dab5a22955761fa62609d68c2660f1923329872"
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
