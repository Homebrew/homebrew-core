class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.11.tar.gz"
  sha256 "acd3a17e6c95acf3154d60c38c90e927e6c531805bc740a040fa111819af380e"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e6bd91fd27b31eeabcde4f1dbcdad830cdfdbdbdf1663767e4b7d30331c1ef4"
    sha256 cellar: :any,                 arm64_sequoia: "092aa82f53ef98b125e6b3f6bd007d46a2946f5f36f4887131c4405bcba4e041"
    sha256 cellar: :any,                 arm64_sonoma:  "2caeb8f24ea53e7b55aec1fe5e545481b5fc8729864f54040063a7058c0ce6fc"
    sha256 cellar: :any,                 arm64_ventura: "899a1bf954d64fccc877e8c9cea5ab44276a6d3fd6bc01af18c147ae65cb657f"
    sha256 cellar: :any,                 sonoma:        "cccbdf7b8f9bf264de8af3ceafa73f761f1d39d9f509998a36c6a7db9e223a96"
    sha256 cellar: :any,                 ventura:       "5be82de1fd51011621fe9d86daa310c738970843d052e1dbee52845bac628e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f734fe0a0e4934c011b98a0c74c3087f7a12d2f03ba895f415f11b1b4f5fdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80d3bd709ca87e2eb02dc6c60c87e37d145ea2df31491ffea0b6373c6cc1f84"
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
