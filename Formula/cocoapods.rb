class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.1.0.tar.gz"
  sha256 "9fcc2503e7ef11d8ecf419d181a9f8495960db1f5a5e38cc5b9571e82a6c04ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f954bd3647ae7c0b3f3afafa350905fbad3bfc554bc9cb3aa583f6dca4c356e" => :sierra
    sha256 "14e754ee227417ab7faed77bac423edfe6a4d8bb1e38a95e3182a409ade29673" => :el_capitan
    sha256 "e4e07c18897cf1c89baeeb94490f1089d915e9e1909de9d42d7ef79b142ee0db" => :yosemite
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
