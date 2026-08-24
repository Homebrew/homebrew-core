class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://download.openzim.org/release/libzim/"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.8.2.tar.gz"
  sha256 "38f8e2139a089f00196f288f52f2d0677a6becc218f380b54ca70b6f162398bd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "71a53670c33594c27b97466972f43e6a44ee14b83f10b383b54f4a25ca5e70af"
    sha256 cellar: :any, arm64_sequoia: "4f2304e9fdda5597b4c0b54b4ca8de80ea46d2f22f90f731d07e036f7e5ad606"
    sha256 cellar: :any, arm64_sonoma:  "0582de4b08ce46e0af4e824f48df4e15ce80691c6366fbeb2760bcaa829266e4"
    sha256 cellar: :any, sonoma:        "38078e1e029ff58954ae8aa1757a29279f221a80e8b97c3dabd3575e8f54f862"
    sha256               arm64_linux:   "5249cd9c9155a9cc7a436919b31d196179ae82ef12be38c0576bba798cffa600"
    sha256               x86_64_linux:  "4a57f4e1fac71920051beaaefeeee8e1adcdba63a44a0098dfdca1d79b99eb60"
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
