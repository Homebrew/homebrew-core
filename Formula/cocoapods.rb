class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.5.tar.gz"
  sha256 "508e5f7a7566b3d05ec4e27417dc0a60bedc8e72618b31cb56713034e71337b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a70fd60007975ce224824b1a8852ba9124faa6753061d0ecc024be4cebd6e8b" => :mojave
    sha256 "6d69384a2bfa22e24189cdaab477fa4a18703e7e5fed859454e822b4f28f4658" => :high_sierra
    sha256 "934d4e8b24722e972ca65ef17e0aa8f9eb6a04b5dcedc93ec47daea096935be1" => :sierra
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
