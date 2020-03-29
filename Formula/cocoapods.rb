class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.9.1.tar.gz"
  sha256 "c5ce17f20f93cba55bde13e9e6e87b1f49b312ab27db4f259226d2c019953bcf"

  bottle do
    sha256 "f375095fa465b420d07e30c81ea1ee96d51f3fd7dd5ca2907af9d9171200651c" => :catalina
    sha256 "6ba9112176eff8173735c2528ddd775e1ae338a31390a0a08bc480e080cd97de" => :mojave
    sha256 "51a8782f5d6cae4c7f0a7070a80f0324e5d8377c2c7ea56cbb229831b3401be4" => :high_sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

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
