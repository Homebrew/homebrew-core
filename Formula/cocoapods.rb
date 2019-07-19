class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.5.tar.gz"
  sha256 "508e5f7a7566b3d05ec4e27417dc0a60bedc8e72618b31cb56713034e71337b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f387194cd57735b086e1744717b9f5b2eb87f943edb99ab02917fac7b6e7cfc" => :mojave
    sha256 "47ba4c250cfe1a396c06307e6a6d00c72304908f00fa1248e43cac0203aae6fd" => :high_sierra
    sha256 "466978eeee2e54084477ceaba5254f38b508f5a8a13870a409114ae38a848ef7" => :sierra
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
