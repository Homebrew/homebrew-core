class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "71f608d1e2a28652e66076f42becc3bbd3e0c8a21ba11a4de226a51459e894a9"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3933494cba07975af38834898f56f291f35ec919fc5f73514b7b50bfe29ce05c"
    sha256 cellar: :any,                 arm64_ventura:  "090d96eeb77c865e2e5389ad6acfe9738adb37586807fa3fd1be1520ed478e4d"
    sha256 cellar: :any,                 arm64_monterey: "f362792216ec5d2ad6479a92d18bc96620d960053d5c5e36a0757e6f6c389f1e"
    sha256 cellar: :any,                 sonoma:         "668bf44b32baf724b9f46245dd4ab0a9a21e85efa14cb353f6ce8a96abe04f3d"
    sha256 cellar: :any,                 ventura:        "986c26b5d8e5610b024038129941838812997fd3bbe2e66c8316703250814fcc"
    sha256 cellar: :any,                 monterey:       "fb1ff0da782f19d0037a35e5382f0a3cb1135c6fb0ec67d71e4a7b170da7f17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6f41c30c8160aea7fac0b81740a31d5c9b2789d259005aed4bd83c2791059b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/liblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "include/libsais.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
