class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.8.4.tar.gz"
  sha256 "7afe0a8f0d1a83d23a3a04c195229c9bec37d114e6b81b41458e65e33138f8c6"

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
