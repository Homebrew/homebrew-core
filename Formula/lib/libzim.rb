class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.2.3.tar.gz"
  sha256 "7c6e7fcaf5bc82447edb12c6c573779af6d77b3b79227da57586e81c4e13f1bf"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "00a0a3a9e17a6cf09d3de5ff755527249bff3d816f99a5adb1d6afa47968fba9"
    sha256 cellar: :any, arm64_sonoma:  "2c0d7acbee282b749a9c760c88f6fb8e7af12d7dba0e3f6311aa555b3f248514"
    sha256 cellar: :any, arm64_ventura: "b4a7c832065ec969960e9fcbdfc1e6a88d11c880a1d16aba435fd8312633b8de"
    sha256 cellar: :any, sonoma:        "e01388b83bd200d3ff68a46874b22b1ae97498e4b3d5f9c5329e6673be6cd48c"
    sha256 cellar: :any, ventura:       "08a2d63cabf9559ddd61a62fced46ce4ea8e1c9efbdda6f6c28f08f9487b6bda"
    sha256               x86_64_linux:  "a3ffacd30b339af12c349bdc37c1891446c03790e817ffc9aaff6a5175e39fb4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@76"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  # Apply commit from open PR to fix build with ICU 76+
  # PR ref: https://github.com/openzim/libzim/pull/936
  patch do
    url "https://github.com/openzim/libzim/commit/48c8c3fa7ad7a54f6df9a5be2676d189bbaf0022.patch?full_index=1"
    sha256 "f88890feab66aec7861b4eaab58202d6417c7c4d3692fe56f0e4b5fba06c64a3"
  end

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

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
