class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.5.0.tar.gz"
  sha256 "0e5290a21a4efe8281dfa2325c59d465ba8ace7ccc1082554763c1a58fdd3b42"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ee245d4f949abd15ebee72df876c3b96f8d7919fec0eefcf0d86ce9d7c16c35"
    sha256 cellar: :any, arm64_sequoia: "fe3827330c0435549535a7055323a6bbb66fdb1bbdca7fcde83056f3fd3f7800"
    sha256 cellar: :any, arm64_sonoma:  "8f640623a17c74f5277a97604f63e02f1604680a8b2002a4d88e0f5b35e659ce"
    sha256 cellar: :any, sonoma:        "7d641aabc6595f26e1e838bab8b701cf8579e2d0dffa062eb9c7b48045dfe990"
    sha256               arm64_linux:   "004399b0e5b8ef999c5d55b8295d0c4e8bc8b935d1368f29f9fd73925e95ee4a"
    sha256               x86_64_linux:  "e2c40e05b046798f4d4129be96011e7fd8d6c78f6cb3b5ba8e92da090f17d95c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
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
