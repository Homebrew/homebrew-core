class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "25c80c99945d7148b61ee4108dbda77e3dda605619ebfc7b880fd074af212b50"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "530fc5db53ed108c1c0cd163d4bcf5293f13e1532ce1b8e84df243fc8776a2e8"
    sha256 cellar: :any,                 arm64_sonoma:  "e12064836d57cbe31bfff4a60388f5ab516ffbbeff39bc157acfaa404b8b43c6"
    sha256 cellar: :any,                 arm64_ventura: "829ff3a96b317b7e56a4f61e7590d776e5dde1f85f40d44d9a7fa599e81ac6d5"
    sha256 cellar: :any,                 sonoma:        "cc56db309bd88c115c2da8c9cb3821c3aa69e2f595b6156b5379b870413af309"
    sha256 cellar: :any,                 ventura:       "118fd79be7a9552aac05652c2d76452a79726769ad59745c7c0160fc9d7d69e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024ff4a47c6340289256a1634b83b8d0bc2201c53df1ad48be3c984b03c9728e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d12688f8f741c93ce811a6207584ff439136520a3df834fd79d9cef3343965"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
