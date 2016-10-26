class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.1.1.tar.gz"
  sha256 "a839330c62a27ba1213a97485b4a242386359d7a38c0869ded73da7d686df5c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "bae474649aa002226198780475e3a954b16f9f3ddd9d357b344ff1f66dd36433" => :sierra
    sha256 "3523d6197dbe39ad866c6a789c5a0962442271ced6697d30d61a1a3e1b5fbfe3" => :el_capitan
    sha256 "94c1827de0a2cadd067deab1678fc77c961ed1b13fd71aa22e4cabca788a31a0" => :yosemite
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
