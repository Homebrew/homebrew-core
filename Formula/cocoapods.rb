class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.0.1.tar.gz"
  sha256 "5ff282d8400a773ffcdf12af45a5cef98cac78a87aea7e0ce3818ab767597da2"

  bottle do
    cellar :any_skip_relocation
    sha256 "805986eb273cac67ab777443d102cc15deb73fda7bf49ede1bfbcf0a186d2911" => :el_capitan
    sha256 "65ebef0ede3b9da11fdae5a1a5ac21424b441db463f8c0b02d92b22f860eb4ff" => :yosemite
    sha256 "218ea92fcb19f52e37cd94c9568cac2495e7e354ced13e56f74fc71eb957113b" => :mavericks
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
