class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.10.1.tar.gz"
  sha256 "7629705179e4bfd894bebe4ed62c28d1cc539103f6d1924f4c8127f46cbd13e1"
  license "MIT"

  bottle do
    sha256 "0caa8953926c827f62d53f9767aed0a904604c0425ea0557b24d738240db809a" => :big_sur
    sha256 "08794cfd260bf206eed3496805816661da367bffdf9af748cd812b1c40a0de75" => :arm64_big_sur
    sha256 "3a05cecba1a15c8cad8baa04b4e6be6eef8159c061b37096012de75132e7cd74" => :catalina
    sha256 "0883b18c75e7cade594eced3d828ccacefafbbb3ead61667bca21e1fbc94970d" => :mojave
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
