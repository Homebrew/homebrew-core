class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "9a3ab90beb94ef4d9cf633f39f3d45fe355401dcffcda067a4e330895afc20d7"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "15b39446e38955cada574e9cfd31ebb7214a280e0eb2b691b60e1593ce2d98c7"
    sha256 cellar: :any, arm64_tahoe:       "030536bce11b4b2e65020b83e9435d2a352c0961c4adc7fadfdb1dfdf38c9676"
    sha256 cellar: :any, arm64_sequoia:     "0f1bf2bef152e9bf1e3c16e86f8b0da198536e6abf8d146e10a0e2441cda268e"
    sha256 cellar: :any, arm64_linux:       "c4502234aab79b4cf272ea81f7f099a1afae1c93d3c93deb87c8e338e1fe730e"
    sha256 cellar: :any, x86_64_linux:      "d7067423e1c3cc4f97a2421d97baeef0f06c8e798c20fc97a4906fc720fb66d9"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLIBSAIS_BUILD_SHARED_LIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
