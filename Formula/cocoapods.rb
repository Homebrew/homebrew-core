class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.0.tar.gz"
  sha256 "eefe349e04e5a7c2f580f4427755437cdaed10ad1fe6890bab8d4dc059d40fe0"

  bottle do
    cellar :any_skip_relocation
    sha256 "deacee4d64a8a6085e81e02e1af9b9eac17f453da36a2d913a4cd7296c17b7da" => :mojave
    sha256 "6498f14fa5ae5f1e578c518722fd9daed1e7c9e0547c62d82f8fca804b84002c" => :high_sierra
    sha256 "04ad35e4113f7167ba482531f1440a798c512b7152cc08470da296f556a1a1e0" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

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
