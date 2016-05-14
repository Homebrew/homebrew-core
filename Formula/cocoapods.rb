class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/0.39.0.tar.gz"
  sha256 "bb43540dad6d284db6175fc773e3b0f3d3a557ec3de012609b57c3ba7c280fd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "805986eb273cac67ab777443d102cc15deb73fda7bf49ede1bfbcf0a186d2911" => :el_capitan
    sha256 "65ebef0ede3b9da11fdae5a1a5ac21424b441db463f8c0b02d92b22f860eb4ff" => :yosemite
    sha256 "218ea92fcb19f52e37cd94c9568cac2495e7e354ced13e56f74fc71eb957113b" => :mavericks
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.0.0.beta.8.tar.gz"
    sha256 "5dc0aa2a6ba68eff0f77f2c620de8a752def0c524934dfaaaf0e20d526908be9"
    version "1.0.0.beta.8"
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
