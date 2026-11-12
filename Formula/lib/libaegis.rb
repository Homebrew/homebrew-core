class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.7.tar.gz"
  sha256 "0c64e1addcfb6297d2dcfaba083c76cd041ff9bf63306498ab2a57b6011e8cb9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1cfb0cf66a1203aa98797b47e1039a99eea8748c3b889971af06764654442a20"
    sha256 cellar: :any, arm64_tahoe:       "6cffa2d6c217571eda0d872c3b4fb9c6aafaed35b71b343c22f66d536fe91d01"
    sha256 cellar: :any, arm64_sequoia:     "7af51a873d026baf98201eca6a08d9b3d4560011559f403007b24e2410ef1c44"
    sha256 cellar: :any, arm64_linux:       "ff61724183e2ea37e6701b56654022038705f61fe8f0c02abcf6bb3cbfb2b2c5"
    sha256 cellar: :any, x86_64_linux:      "127ced10a47aaf2a1ef14067a96584812b54afa82a47b1dfbff23d41b6ed2c2e"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # The library contains multiple implementations, from which the most optimal is
    # selected at runtime, see https://github.com/aegis-aead/libaegis/blob/main/src/common/cpu.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <aegis.h>

      int main() {
        int result = aegis_init();
        if (result != 0) {
          printf("aegis_init failed with result %d\n", result);
          return 1;
        } else {
          printf("aegis_init succeeded\n");
          return 0;
        }
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laegis", "-o", "test"
    system "./test"
  end
end
