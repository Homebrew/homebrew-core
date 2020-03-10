class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.9.1.tar.gz"
  sha256 "c5ce17f20f93cba55bde13e9e6e87b1f49b312ab27db4f259226d2c019953bcf"

  bottle do
    sha256 "ccb54a7ba857f8ad6d11ea302d5d40cebcd3e18b805aa3168af54c84f4f925b9" => :catalina
    sha256 "099881b0e05a5720acc2881b5910bcd77fbd019b9157e12d2d58873a4a5f91d8" => :mojave
    sha256 "2df42c5e39984f0df93d53d75ba55e191e96cb18f385fb4c75ef84b449133790" => :high_sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
