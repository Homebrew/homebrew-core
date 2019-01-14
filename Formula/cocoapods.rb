class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.5.3.tar.gz"
  sha256 "04593483efe1279c93cfc2bf25866a6e1a3d0c49c0c10602b060611c1e8b5e20"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "5e0fa01f44b64e0c230fa768cd211a86d0cf28c7415128cd46b162e90616a199" => :mojave
    sha256 "e711a156660e3580237f315c2cfa38d5fd54d4211cc471f77de75c9db3f47321" => :high_sierra
    sha256 "2c50c930d1680af39c7a4f21d2ef3714b04074aa6c3d586d4026925d7e30b452" => :sierra
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
