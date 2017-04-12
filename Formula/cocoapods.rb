class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.2.1.tar.gz"
  sha256 "e5a31921f624649ff780d2c146c77fe194be8740de2c18991bb274d56a35ea69"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd22a54023e078b33ec533c2dd24eff762337122cd2c06a0cf8a30e7bc5ad38d" => :sierra
    sha256 "9d317193d69c036226df8bf8268238ee4370106a2eb78e1a6d9bd872aa15b65f" => :el_capitan
    sha256 "d31d6d9de2bc4aa582d5804ea9d1f5485d54ea6981f85db55ad69200dab06a25" => :yosemite
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
