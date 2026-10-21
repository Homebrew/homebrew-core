class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "9151a8b0ebaf460a889630e9e11b96c9e4cc71934e8dd8ccd084707c6751e853"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f5eb897368d39162bafefb896bf10b16d63ef94cc901560e2fc6ae7f06a706e9"
    sha256 cellar: :any, arm64_tahoe:       "f6234b35b2bdc12d3594e4842901ad6f85a1ce92588b68f7f368bb217c696f40"
    sha256 cellar: :any, arm64_sequoia:     "6806d4d453e7370a68f61e3c6f8683ea50f6052824367679825c97e2fa2f1233"
    sha256 cellar: :any, arm64_linux:       "145a5fb853ec3c2fc0ba7e2a8661a52e07414b217a3a4133ce260da6c0e829f1"
    sha256 cellar: :any, x86_64_linux:      "b2d35a25eac9963260a284504fd729384c38f6723137ba0c7671400c45677d2f"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_LTO=ON",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DROARING_USE_CPM=OFF",
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
