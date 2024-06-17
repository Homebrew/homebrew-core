class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "6de93b078a89ea85ee03916a7a9cfb1003a9946dee9d1e780a97c84d80b49476"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e7dcbd6409bd38a345a5b3a8cdb3cdd7f062167146f929c7d9280a73db6b810a"
    sha256 cellar: :any,                 arm64_ventura:  "34748cc11a43a250549ec5b499b4413d096447fdaf407f4ca19d0ae05a70c947"
    sha256 cellar: :any,                 arm64_monterey: "82a124ba94952657fae3c866c5bab61781200a138bddf28c9bf0cccf7b4e951d"
    sha256 cellar: :any,                 sonoma:         "ab8c52d740afa4e9a056ef3a16fda6238fb8a4b1ccc3801082251fab2064b485"
    sha256 cellar: :any,                 ventura:        "0224840a09950751fc47f8a02c32d0a1ce23704a2c16c87ec09dc11d52220818"
    sha256 cellar: :any,                 monterey:       "63ab8d69919c98476a1c3fe44503d4d735671f8f941ef8051a4324669c1b87e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e235743309631550a36d18cee64c084d42fa078d908a673aac63f76295c868"
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
