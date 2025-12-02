class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.4.3.tar.gz"
  sha256 "affe456e3bbd941ac97c64a9d9d9988be1c80f07f6071e38170aceca94dce238"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "326b7fbb3f26f0d0a93d6fa9182a756f2eb0fc1ee755214779625c02998ef9d8"
    sha256 cellar: :any,                 arm64_sequoia: "5e9024bd872cc7ac0b0aae044ee8ad95ed1fba0e29bf49ce9aa3f5978afc435f"
    sha256 cellar: :any,                 arm64_sonoma:  "52d361591bd7902aa7aaaa5149628d7d1f0309adcf7c2a1a760e593c8d2f05ad"
    sha256 cellar: :any,                 sonoma:        "8d46e96a3229e9546984c9caa86a2b6ed5fb689ff3baad0ab561dab7fa39afbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85851f5276e170743120f502a91ee9730fa26b8a697af1324e60ff436c76e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179b1ed0932ae83f7ef12962a8b1cd406b21b57d3eae5819fd196cdf1290861d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DROARING_BUILD_LTO=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
