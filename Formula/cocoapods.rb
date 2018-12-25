class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.5.3.tar.gz"
  sha256 "04593483efe1279c93cfc2bf25866a6e1a3d0c49c0c10602b060611c1e8b5e20"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "65f3a3385f039d28d4851d32cfaa248458f7730241fa7f8b8d4981e04ae80ce2" => :mojave
    sha256 "3a81b6752d559e01b6aaab830aaca5d8e89e946bb2f62793e7fa51a144b3f683" => :high_sierra
    sha256 "d62738d8793c6de966233eccfc2d9cb08de1a932ff9be672add02b89124be6af" => :sierra
    sha256 "825dcdb5aed45f84a5bd6c0a7dc43569e9e87ce1e705af3198015a6966697e5e" => :el_capitan
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
