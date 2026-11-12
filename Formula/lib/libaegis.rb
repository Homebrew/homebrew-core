class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.10.7.tar.gz"
  sha256 "0c64e1addcfb6297d2dcfaba083c76cd041ff9bf63306498ab2a57b6011e8cb9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc4fe27e728f04ca93a5a781e846f73ed8b7572b4e8fcb4273455c34c7f6826a"
    sha256 cellar: :any, arm64_tahoe:       "c59c43ad6fd7d1aac73412d9cf382916a3904b26d48903b2456e51cc19296de0"
    sha256 cellar: :any, arm64_sequoia:     "681b3b703a09efee168e1a541f1c1191ebd9d4767c2720b6e00e564012b7d960"
    sha256 cellar: :any, arm64_linux:       "9352bdb9cee0fa158745cd36b455f392d06a560ea5fae821dee0eb3fb8187714"
    sha256 cellar: :any, x86_64_linux:      "e42af2a777c22f9815288dfe45dd58bda4e47a4f54d63fb07a7ba62d45bf5ba2"
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
