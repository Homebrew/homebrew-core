class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "11cc5d37b2d719e02936c71db83d3a5d1f3d27c59005348f4ee6417a63617b77"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdd7b03a75bb611081f0dbf5f2e76c6d363273f6362d241dddaac0cb9281c8fe"
    sha256 cellar: :any,                 arm64_sequoia: "c9318da7633a08b64712d5944091440bcb2dc2b41220696e851044acf56f5648"
    sha256 cellar: :any,                 arm64_sonoma:  "3c7f1be6487e91eb0128295a3b8058fd493b2853355de73cf6b0bb0c593f535d"
    sha256 cellar: :any,                 sonoma:        "ee21ef439042bec0b9340e8c9d1adca939c83c34f3157434c0eb42f86a90abdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2aa6345f1775c548acb09d3c5a48bce22b6f3e259b2d1ecd2ca94b051a10923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c551dda816710eba9e09b5744fd9a668c38a32464774217ca3b28de876536416"
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
