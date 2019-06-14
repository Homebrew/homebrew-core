class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.7.2.tar.gz"
  sha256 "7b702282b972438e8a7bdad13fdb6cbcbc0e806b0f24398a50fe7c9f4b563f9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbfdae2a8c69806bf1875751771d99fa0efb0675c5d748771f71d323cf724b93" => :mojave
    sha256 "386685e850bd0fd036b0c52bfe8ac5baf3b0eb8d1554c2fb136324e3a1617305" => :high_sierra
    sha256 "cfb29f44172f5a9ef395f11a8ff7bbfce7eb13ff3537c9d47c178eb90c1b47ea" => :sierra
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
