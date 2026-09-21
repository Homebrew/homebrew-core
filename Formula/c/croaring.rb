class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.2.2.tar.gz"
  sha256 "a7d8c10c954a971b7e2996b498cb7600e5002637412f4198dcd600b415e1eb5c"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dfcae21fcee5830e02b00125c277ea605f31eed1b65b817b0d4ded6d13ac574b"
    sha256 cellar: :any, arm64_tahoe:       "bcb1cc116aa3c4c33dc0e1a0f7c0704d04df5a0b27746959302ccb134d255427"
    sha256 cellar: :any, arm64_sequoia:     "66057511474f02e72f08e9d2eb391c98b1808264bbcd7a742d6b710463c8e8fa"
    sha256 cellar: :any, arm64_linux:       "87a5b87431c75e69e8b7431fa8f1e3b17530bb06b882373be7dc4a569e865926"
    sha256 cellar: :any, x86_64_linux:      "5987526d4d9d71c0b7607f65a44ad91e2cc6cf23af3e604bfb0ddd580103c40f"
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
