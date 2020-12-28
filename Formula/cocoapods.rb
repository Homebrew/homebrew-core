class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.10.0.tar.gz"
  sha256 "d44c70047020ea114ca950df6d4499b1f86e5e7bbd3536a46f6fa3e32f1df21e"
  license "MIT"
  revision 2

  bottle do
    sha256 "d55424b1e441e989fe4865369e0322739bce49806accea459f5e726677e532d7" => :big_sur
    sha256 "1dcddcefa7a9cc5658bf62ef7e0e05bd43e6542fd84959872bdee70345cce6fb" => :arm64_big_sur
    sha256 "0018d5a725bcc02e53d5c9b10b9c6e396c3a2ece14b7c413efce27c67bdccfcb" => :catalina
    sha256 "ad9286fda5eb301017348df283e0c68ae135e267b4506f090b5504835e961e60" => :mojave
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
