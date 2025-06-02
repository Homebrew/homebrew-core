class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "ecf4611c18fefd8d4377343e4dc3f257ae17a501301a13f7cb7585c836405d39"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54b8afff60b856c0884c71de1dd1f1e6409a55b2be1d49b8b673dad9e47b2510"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d9e7b22a085837f05ad3b29b6e20fca750f0c5fc3028c4fc5a672fb68eeb7c"
    sha256 cellar: :any,                 arm64_ventura: "399524c4f5c23885e1115134517a85c32e91a66eb6b174323a05eb3fe4ec81af"
    sha256 cellar: :any,                 sonoma:        "9f96dfbd1f3c5e47135ffc73fe8ad7b078fe1e288d789c85cb61253cd51c529d"
    sha256 cellar: :any,                 ventura:       "9a8a3785b9eb046ff961db993c3b5c2e8a038ce933c0df45721f4cf689bfe80e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c94849ebbeaf7ca8e3b06c9bd5be34a8e5f1fba3c41c78014744c72527b20e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6cd3dd97d73a21ed12b1305f8a8ec133a583088413f62bad03c3fb3908c794"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/libsais")
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
