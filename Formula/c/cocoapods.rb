class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.16.2.tar.gz"
  sha256 "3067f21a0025aedb5869c7080b6c4b3fa55d397b94fadc8c3037a28a6cee274c"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e99020093a04819ec6b1641074829779977180837668593d1cefd9f5a1ac83f"
    sha256 cellar: :any,                 arm64_sequoia: "b2ac49db7a229b2ccb5c8984ca0f12764f433a4c9d14b186ccdef45cbffbd13b"
    sha256 cellar: :any,                 arm64_sonoma:  "8757b6f6609c8934bb149cd16a36dd23bb238ee61521628f6afa4d47bf981dc6"
    sha256 cellar: :any,                 sonoma:        "be1632548200a7d64a0b80b6e6d0640674d7f3462d3ad64a2e31ea2882e44542"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9d5a71964e1279d0157beaff7ab780807aeb455d4b466e5f12a54c66acc3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc455c1453ff790433e652d66b708c13fd295c2ec666074c4fd422fb9dfff37e"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"
  uses_from_macos "libffi"

  conflicts_with cask: "cocoapods-app", because: "both install `pod` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pod", "list"
  end
end
