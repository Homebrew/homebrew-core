class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.3.1.tar.gz"
  sha256 "6ca7d696462a9d7109fd47e4143f0bb78683ec00aeb3bc2e4d8b245c1d5e3c13"

  bottle do
    cellar :any_skip_relocation
    sha256 "0541d42091e0a98568bef37e8aa687fa8eef35357d9f1f23f57a60950107de88" => :sierra
    sha256 "cfe2d6c713b728d0433b6e1c1553bbe3a04f8e1397fbae885fbc89ca6c85ed56" => :el_capitan
    sha256 "f309be4487af3f81dab480f6a2051d9e1c489d99388a4f891533b6a74bafd946" => :yosemite
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
