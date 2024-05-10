class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "01852e93305fe197d8f2ffdc32a856e78d6796aa3f40708325084c55b450747a"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48994da537ee3cf94b45db4f58494aa421479e86d40d9cf6d12d4d408164e5dd"
    sha256 cellar: :any,                 arm64_ventura:  "d95d28c5d77f4eca24b01e16818d7c73122bc6503150bc46509dc1bbec37a7a4"
    sha256 cellar: :any,                 arm64_monterey: "4b9f7fc20c6dc6ef4c9bc16cafcd9808bf778eb5aa8889433cbf36eb46b586ef"
    sha256 cellar: :any,                 sonoma:         "13589dda6155c019a1439ba479446c3683df185fbdf71f5ee3d8bf38e4e098a9"
    sha256 cellar: :any,                 ventura:        "f63f2f95f2afcc3bff45df68bb5786db3b2fcb4355642c3d14cc2caffd1e8671"
    sha256 cellar: :any,                 monterey:       "8a58051d0582b050825ce02e4be06c40c81bfb75d6c665bff4d98ac16946a264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c5361a38f6d7fc544ace377199d8b0d05baa0c1246def77e00e49a453fdac4"
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
