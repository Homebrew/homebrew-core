class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.5.0.tar.gz"
  sha256 "6726def006066acd7ee340dc1eadc07376b695cee7b8c1ccfbc6f3140754a451"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce5e3502e050549a993a35b616a22635491b34e66a58496d3891fff70f68f07a" => :high_sierra
    sha256 "3f937ce92a457953cbac1a76ca20a22e45a10223a82791c148e0a2c596aa6829" => :sierra
    sha256 "27e49f932e4d8833f468199ae9c49ac16a1a815967f17642638ac6d61d0ae4a7" => :el_capitan
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
