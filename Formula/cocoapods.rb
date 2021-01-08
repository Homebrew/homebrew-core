class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.10.1.tar.gz"
  sha256 "7629705179e4bfd894bebe4ed62c28d1cc539103f6d1924f4c8127f46cbd13e1"
  license "MIT"

  bottle do
    sha256 "a5532d13f702b48348c7d21c6b1a80b56c8e638aa0624e8d56e7497bfc17e657" => :big_sur
    sha256 "83ab1ef7d462362083fbc9bf079d0fd437b47f5207a226a06833e5d2d72882db" => :arm64_big_sur
    sha256 "6200a5f99093050fcd136c1886acf33c311e56031b1fded1ee60ec5632a6ef2f" => :catalina
    sha256 "7b935fe6c4ac9e379fa66bca56eac7914826baad13a5935afdf250cc2bc919a5" => :mojave
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
