class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "b4adf04f32e411bcb0d5ff1b5a616c64129c3b35ef29eddc7f18fb626031de7a"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "71798230e0812f09a513abb2d6f6f9d414199f6020de68b0155a57349fde1cd0"
    sha256 cellar: :any,                 arm64_sonoma:  "02a2cd486eacd8a0024b3f146d258a452ac91de055fc79e60607b4447c43143d"
    sha256 cellar: :any,                 arm64_ventura: "be3653aabdd632b2a1ff411c322f7d48120ab416acf294d7d4a8853bff45c080"
    sha256 cellar: :any,                 sonoma:        "4ce985b643d0aa19ec9602dde6d39d6108fd9fa17925e74fec29752530079c81"
    sha256 cellar: :any,                 ventura:       "6824497f202de858ba1ff2d9c2d926a3bc9f0ae71648b12bbe3a8331d08ca1cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be08cee2abbb93bc7e3a2bb078569f55fd38de28ad68a315f807355b5cca89f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37dc5e73a77d10484285a2d4efc121b6d1fb972695c2964904affc63f808b98"
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
