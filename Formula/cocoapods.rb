class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.2.tar.gz"
  sha256 "c1f7454a93e334484cc15ec8a88ded4080bf5e39df2b0dff729a2e77044dc3df"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4d468b2e7fdec4d80dfa63c3399e21519c842af012e310f15c0c5b4450642f0b"
    sha256                               big_sur:       "594546dcde868d93407a2f056f7ee76769b90d4742f9a3b29bdfaba32addb61a"
    sha256                               catalina:      "ca65ce465468779c6617a6fe27bc5e0768815b3ab49df11762e6a5196febf1b7"
    sha256 cellar: :any,                 mojave:        "966d3229dc326393b68e8febe77540758650f555e9abcb8d70926be4aa67d3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "872f8d21b42f463d7b6f203f78121316b386c456c943425e17ca258bd17602be"
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
