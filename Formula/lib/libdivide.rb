class Libdivide < Formula
  desc "Optimized integer division"
  homepage "https://libdivide.com"
  url "https://github.com/ridiculousfish/libdivide/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "73ae910c4cdbda823b7df2c1e0e1e7427464ebc43fc770b1a30bb598cb703f49"
  license any_of: ["Zlib", "BSL-1.0"]
  head "https://github.com/ridiculousfish/libdivide.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bcba36eed605054470693093dd47baf69817c8aaa85d9a046e5f665e124fce8"
  end

  depends_on "cmake" => :build

  # include sanitisers for release build, upstream pr ref, https://github.com/ridiculousfish/libdivide/pull/129
  patch do
    url "https://github.com/ridiculousfish/libdivide/commit/41c04ea14b9c661e891ef35b122c5cce74837c8a.patch?full_index=1"
    sha256 "e431c9dd5163d1636dc53e689b33d27f38f9dce674532f8e1df1ff90ae112efc"
  end

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
