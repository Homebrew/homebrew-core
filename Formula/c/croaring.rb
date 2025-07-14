class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "fd5afacb174322ce45bea333076440e615fb8cc2751b537c8051ac2d39f52b1e"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d142c4656993fb4a06e3a44a187777b058c91b5e65e2e69f733d49f14ec1ba3d"
    sha256 cellar: :any,                 arm64_sonoma:  "934005ef7f67b0fd312c587a6dadcbc18167ef7fc6d4d2818974f14cfd179a5e"
    sha256 cellar: :any,                 arm64_ventura: "20dec72c1f1995808e0dcba069e5acd8035bd7fb00efeabf1cfe719c381339c2"
    sha256 cellar: :any,                 sonoma:        "83461d37577ac557cebcefd4babc99a390c36fe38f463ae12dd02c5a13d13ef4"
    sha256 cellar: :any,                 ventura:       "701738a46d565f51899d6241b82295fe6800ec6c52aaf6290d08fb91b66ba865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d01a0204300f1ce4c76b7b5b9eaea9553793e566cc310236cf0fd0454bad99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a965535283c4b8ec4526691a52e99d6255df33c55c32d6bab29a1585deec3fc"
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
