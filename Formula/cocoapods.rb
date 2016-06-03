class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.0.1.tar.gz"
  sha256 "5ff282d8400a773ffcdf12af45a5cef98cac78a87aea7e0ce3818ab767597da2"

  bottle do
    cellar :any_skip_relocation
    sha256 "736b65d17ed27bac64e14c7e932c1b3959d57d652d5d72a335c17494b9c5e2ad" => :el_capitan
    sha256 "df75ba653f028491ea817cc21d1993adfa39090d24575226404fe5220da90082" => :yosemite
    sha256 "0e60242bb181b9a0b66bdbe3b105780330c737da4bb0dea9bd6408f2093aa96a" => :mavericks
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
