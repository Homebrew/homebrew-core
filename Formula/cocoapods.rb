class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.0.tar.gz"
  sha256 "eefe349e04e5a7c2f580f4427755437cdaed10ad1fe6890bab8d4dc059d40fe0"

  bottle do
    cellar :any_skip_relocation
    sha256 "238cc9cdc173abeea42cb5d248f383260de75dc8e8408240da56bf3e5782074c" => :mojave
    sha256 "6f2a512bf11b6f7e07989afcf31b5c2e9644cdb56887d6cfe2716e9172e429f3" => :high_sierra
    sha256 "1daf1a457fc8b800c89c61cf8bccc92890aa1bfe0ddb0b47ef9d9bb17d45283f" => :sierra
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
