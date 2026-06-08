class Libdivide < Formula
  desc "Optimized integer division"
  homepage "https://libdivide.com"
  url "https://github.com/ridiculousfish/libdivide/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "de3933bf2fd21300d99fcc6460a8a4a1343ae90b965d6893f044c350bac68c6e"
  license any_of: ["Zlib", "BSL-1.0"]
  head "https://github.com/ridiculousfish/libdivide.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73dd9a2cb0aa33ae2d15a3beeba9b8ff3a5cccca5c0c6d2a41eb77cbb993166b"
  end

  depends_on "cmake" => :build

  def install
    # Skip `cmake --build`, as this is only for building tests.
    system "cmake", "-S", ".", "-B", "build", "-DLIBDIVIDE_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"libdivide-test.c").write <<~C
      #include "libdivide.h"
      #include <assert.h>

      int sum_of_quotients(const int *numers, size_t count, int d) {
        int result = 0;
        struct libdivide_s32_t fast_d = libdivide_s32_gen(d);
        for (size_t i = 0; i < count; i++)
          result += libdivide_s32_do(numers[i], &fast_d);
        return result;
      }

      int main(void) {
        const int numers[] = {2, 4, 6, 8, 10};
        size_t count = sizeof(numers) / sizeof(int);
        int d = 2;
        int result = sum_of_quotients(numers, count, d);
        assert(result == 15);
        return 0;
      }
    C

    macro_suffix = Hardware::CPU.arm? ? "NEON" : "SSE2"
    ENV.append_to_cflags "-I#{include} -DLIBDIVIDE_#{macro_suffix}"

    system "make", "libdivide-test"
    system "./libdivide-test"
  end
end
