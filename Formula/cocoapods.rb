class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"

  stable do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.0.1.tar.gz"
    sha256 "5ff282d8400a773ffcdf12af45a5cef98cac78a87aea7e0ce3818ab767597da2"

    patch do
      # Avoid use of activesupport version 5 (which requires Ruby >= 2.2.2)
      # https://github.com/CocoaPods/CocoaPods/pull/5602
      # https://github.com/CocoaPods/CocoaPods/commit/c6e557b
      url "https://raw.githubusercontent.com/zmwangx/patches/4cb8f3cbcf9caf1056e7ddbddb2e114ed2b18536/cocoapods/patch-activesupport-4.x.diff"
      sha256 "4448552b4c2ea952a9a30d15be50e09c2eca73f29ff6029db215afe244aa7bc9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0bb3e9695f0de5da779c72ae2512c8abbbf735b03939610ae8c89f71e1132e09" => :sierra
    sha256 "736b65d17ed27bac64e14c7e932c1b3959d57d652d5d72a335c17494b9c5e2ad" => :el_capitan
    sha256 "df75ba653f028491ea817cc21d1993adfa39090d24575226404fe5220da90082" => :yosemite
    sha256 "0e60242bb181b9a0b66bdbe3b105780330c737da4bb0dea9bd6408f2093aa96a" => :mavericks
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.1.0.rc.3.tar.gz"
    version "1.1.0.rc.3"
    sha256 "e058674db3319f9376fef01b5f89771d336e6436608699363f01142b7777c63e"
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
