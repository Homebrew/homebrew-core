class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.14.3.tar.gz"
  sha256 "de05766e5771e0cef7af89f73b0e42a1f1c52a76ce1288592cd9511bcd688a9e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "659ed73f0da29fb6bc21269a51d83d60ac069cc0ca42548776149a2a1f839928"
    sha256 cellar: :any,                 arm64_ventura:  "b2b02391270c4397ed07fc3f547a0956562e9c916d6c901931e4b6d9b7f59416"
    sha256 cellar: :any,                 arm64_monterey: "c4da45ab76b118bf8336704fd134209341efcbfbd0d6f9ebb439ded268802a35"
    sha256 cellar: :any,                 sonoma:         "4bcebefe7753f3db1be8379844e0eb987c530ee5069027a574f096ee3a7ed1c9"
    sha256 cellar: :any,                 ventura:        "139bf64804df7abcf4465e6e71e03bf8d5cc9d8b39306c0b001fe7de16f3f349"
    sha256 cellar: :any,                 monterey:       "d27fccc4a9f4ecb8b8384ecd764878137c5ec0742eb4080bf87f409a3007e66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97254aa1331bd0dcf0e1d22d9166c56767a03418586bf213d5b19555c4a6cfd4"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
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
