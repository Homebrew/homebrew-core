class Libaegis < Formula
  desc "Portable C implementations of the AEGIS family of encryption algorithms"
  homepage "https://github.com/aegis-aead/libaegis"
  url "https://github.com/aegis-aead/libaegis/archive/refs/tags/0.4.5.tar.gz"
  sha256 "ce855320369f5e46d4c3512bf28a0cb8b8260b6d079b6b9bfda61ccd452fe9ce"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1b48f7d944a1efaf012835ebb0a4d0dba36a54adf00d83f85d8ed8718bb9d7a"
    sha256 cellar: :any,                 arm64_sequoia: "6b79e84ea50fd699153450124e58979f68be5226595b2ebc432b3ca9db2cc83b"
    sha256 cellar: :any,                 arm64_sonoma:  "ac6041073171b59762aa5f273fda40e93146f9d9f572046e4451c4e91c9bf3c1"
    sha256 cellar: :any,                 sonoma:        "44df6bc158dc5bedc84b2f712c90c6f55fd7e58485d220e4df71f48d4ffd2385"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae17516ae33b9cc90eb29d8760d29662026cb2fac06b0e0dd4a5f27a8568146a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9074a6d5299fc0c95acd349c84a66791c5458ff3b49433b8318291c248d6b837"
  end

  depends_on "cmake" => :build

  on_arm do
    on_linux do
      depends_on "llvm" => :build
    end

    fails_with :gcc do
      version "12"
      cause "error: inlining failed in call to 'always_inline' 'veor3q_u8'"
    end
  end

  def install
    ENV.llvm_clang if OS.linux? && Hardware::CPU.arm?

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
