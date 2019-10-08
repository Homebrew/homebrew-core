class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.8.3.tar.gz"
  sha256 "204f41f14ca87de84c48c8a24311e8344ac73c1df67ea459545c322a663f95da"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b9ed9fbfebca70e81845558318cd83e9a7c73ea7aa63c35875f59ae1576437" => :catalina
    sha256 "4045649812030c32ff3d6bda57c2dfb1928cb5711672deed6bb02c807b850c9a" => :mojave
    sha256 "9696171cd45e6f9213536d4ddb289be1efeb4e0a5b3603c16f693db0ac5f98d6" => :high_sierra
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
