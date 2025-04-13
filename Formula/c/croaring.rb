class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "ec6e0e2ce55b09e8cc6a9b5d2e692ae19ddeebd68fa64712c6b6bb8f9ac2ce11"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ac5547b7e96a03511593f490478459bf843123fb0388a10192c4866d15640328"
    sha256 cellar: :any,                 arm64_sonoma:  "4e7d59f81893acfe79bf3d03eae07d9f1f287ea936815ca2481d2a63c5e5f65b"
    sha256 cellar: :any,                 arm64_ventura: "1650944f58f8c7b94e8216d05a1a13a049001c7e1712f41b21b2a93d503d7807"
    sha256 cellar: :any,                 sonoma:        "8bec472ae2241b6dc63ef1c381caa1ff1ea0f6cc5e0bdb7b688cde8fea94bb9f"
    sha256 cellar: :any,                 ventura:       "3e72e520c7a3b475bc09f133d1608cac43a95a7a45fbcfe44e82376b70539346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b6da559e81a316bcaadae18c77bb5eec72eb1f4f006c37cf7681a6b068157d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8045b01ecf06b1e65b120266c6ee0814fec779727e817ee87f607c68e333cf"
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
