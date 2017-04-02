class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.2.0.tar.gz"
  sha256 "715caded3e7c614b5c80d132f79b005ea4a83136a69077452623698d66ce8b1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd22a54023e078b33ec533c2dd24eff762337122cd2c06a0cf8a30e7bc5ad38d" => :sierra
    sha256 "9d317193d69c036226df8bf8268238ee4370106a2eb78e1a6d9bd872aa15b65f" => :el_capitan
    sha256 "d31d6d9de2bc4aa582d5804ea9d1f5485d54ea6981f85db55ad69200dab06a25" => :yosemite
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.2.1.beta.1.tar.gz"
    version "1.2.1.beta.1"
    sha256 "df3f5ad6171f9b5852b722bbea9bbc3039318c295b28fccd128403205a2aa5b9"
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
