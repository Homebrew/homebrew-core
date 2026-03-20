class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.0.tar.gz"
  sha256 "920a0909e68d8efb23ac16ccd38ca66e0a4e17e51a53417fe0dc289e55e0ee27"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aee1c91e67b8f6a9db2feb21428bad2be42c507b3e8f2c27d3a799df2a16e516"
    sha256 cellar: :any,                 arm64_sequoia: "2cfc22039fc97ef3d952b3770df71e70792d7e60cad933ef75913f560928ee9e"
    sha256 cellar: :any,                 arm64_sonoma:  "1e4552d06879c44f86751eb40ce0e52ee82d1390af6fa53126d0f79fb3ec8898"
    sha256 cellar: :any,                 sonoma:        "a51d5b8fa1fb5f6bb69d862398ee03e086da87ab0a6294501e0b184c7149dc8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0600848ffd567c5fecae3f5d02afb7842d6f8e86f6abbcb3545187abbfde4541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f718512bca9f6d68ef92fa2edf1059cc602e368e7eb9c5f9ae29ee001f8c00"
  end

  depends_on "cmake" => :build

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
