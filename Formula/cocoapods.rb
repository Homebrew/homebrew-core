class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.5.2.tar.gz"
  sha256 "9ba4cd230144dcf4f5f8379c4161cc93c68f7d8056608ff38ce0b803ecc5585e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac096c49ab13532dc62f895401be6c24d760b0199bc4821fd1d099bfb92d382c" => :high_sierra
    sha256 "e8e9af96082c3ed6aa61dcf1bb46d6e3ba7fbdfb6be0333b2ebd20932066c8ce" => :sierra
    sha256 "4c2d737c31de886bc1a855b65bcae14c2c9c65850c45b76b2f60c53ced8bf137" => :el_capitan
  end

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
