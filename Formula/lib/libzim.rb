class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://download.openzim.org/release/libzim/"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.8.2.tar.gz"
  sha256 "38f8e2139a089f00196f288f52f2d0677a6becc218f380b54ca70b6f162398bd"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0db912894c4387fe3b132a639247bb16e1f3ee86b13e5374d4189bde99eb2b46"
    sha256 cellar: :any, arm64_tahoe:       "2985000cf5aededc859768d588463139f7a38149984c0d7059114dbb3975f1a1"
    sha256 cellar: :any, arm64_sequoia:     "eba12048cdf92f2f6582b2f541b45911bd36e68498e56809f8f2719b6daad3b7"
    sha256 cellar: :any, arm64_linux:       "d1667f97783814bab1f781293f37f3ab8bd8d265770cc6e0a28f27cca0821ca6"
    sha256 cellar: :any, x86_64_linux:      "93b6d3cb64bfe6a2668226760e9229ab5eed25189321712b27711e2115bacf2c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@79"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <zim/version.h>
      int main(void) {
        zim::printVersions(); // first line should print "libzim <version>"
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
