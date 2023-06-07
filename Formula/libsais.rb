class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "45d37dc12975c4d40db786f322cd6dcfd9f56a8f23741205fcd0fca6ec0bf246"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3f7cf156031c58cd43aa63838edd85f7f8b00f7d28e0f62a076bb4f30129a0f"
    sha256 cellar: :any,                 arm64_monterey: "6305881a8579ea1c15ad2cb5a8531edbf6817b0b37d8282998c6dcffae3832db"
    sha256 cellar: :any,                 arm64_big_sur:  "ab217c02a0b3dc17772557ff7144371c45d468af0174e61d7e8975e13a859318"
    sha256 cellar: :any,                 ventura:        "d377a2ebcdb7161b8d76b895245ebf6ebbf5809c52eb7cd1990a568fb5f070fe"
    sha256 cellar: :any,                 monterey:       "8009459840d9f8f470dd9af3b32cdb6c73fdf4014f9d54910bafddafd61e69d2"
    sha256 cellar: :any,                 big_sur:        "5191f9864ce178045da8775789e58a057f97d09dfdd09ada4950a05ad1216adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c8074d6679c238dd5481e53ffb4459dd576b0b3be9f9cf344b6e4af291477d"
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
