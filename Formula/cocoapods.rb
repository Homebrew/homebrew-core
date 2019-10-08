class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.8.3.tar.gz"
  sha256 "204f41f14ca87de84c48c8a24311e8344ac73c1df67ea459545c322a663f95da"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0a43af8341910cd0d4d58d242ef5c6ff9b0d1f2fa36c941cd84d1d35418fd87" => :catalina
    sha256 "079f180eb3f8e93cf485fd8da4a469848e669cd0afa2646ac0b298c533f67aee" => :mojave
    sha256 "412208a9da3ba6c91ffcafbe5a11d5d829a545066ffd5a5b84357437afbe5338" => :high_sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
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
