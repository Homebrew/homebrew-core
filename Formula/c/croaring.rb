class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.12.tar.gz"
  sha256 "9f1602d7ff83e84ce0a5928129bb957a1eeacd3b092b39e21f5f0b931682b8d6"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c181141bee0e60903b75ed53a29c92010bbee5694f4299bcf3c652d97580faf"
    sha256 cellar: :any,                 arm64_sequoia: "9e43db58410ed3517e6170fc7b9110bc041a847185ef9a257e1686e7ec0a2166"
    sha256 cellar: :any,                 arm64_sonoma:  "6265bf2951361e67af47bc0a03ba39398c550941e77e35bd7a921bf71a5d4bdc"
    sha256 cellar: :any,                 sonoma:        "56623dc3d26a8d31c346e15cb92c8c1e672eaa26ec9d7e4650c7af8434f24f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c6e9c6c68dac3aec3fb00bf2b8da7fdc318231cf0d99d001ab49ca40c64d868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed87a2ccd4753fc95a45671f1c8942257d2bc312a00f490f6622ec5afbbf13d7"
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
