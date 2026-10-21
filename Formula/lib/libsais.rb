class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "011dd352ad3792483b6a84dfa1fa191a78f310b536773315d278aaf7c61e66b3"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b888c36277cf41b1a70526be91ed0b19b328d2c34a0a9a7062b147e5412c448c"
    sha256 cellar: :any, arm64_tahoe:       "08275f42379e0e1c4f992c404fd5b597a7dd08e6ff10b909d5ea88253ee8e482"
    sha256 cellar: :any, arm64_sequoia:     "208205756e92c767a4b597fab7abac80e5b098d19219af428f967011163ead91"
    sha256 cellar: :any, arm64_linux:       "72c6eb851b18801b8fb93fa1837d17f7a1c80a4eefa8b5e833963637e0fa5d41"
    sha256 cellar: :any, x86_64_linux:      "04059478085f811b859ca4a179377897f00e7e9a9b0d01fef2e28e84c8d742e7"
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
