class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v1.1.5.tar.gz"
  sha256 "5210a277ce83c3099dfee41d494c28aec61bdbc9160b3b124cb5afeab49cd123"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56106a1229f866173938a9b3da95f3a9e64c829b843756fcf93fede1321fc859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "682b6e9020e45693c2e505ce2649017eee0683625f4160647d8504283b7c9502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebb5efd2efef956be9297d94436c1da2575a960fc2f82062d66e2e1cd62e70b8"
    sha256 cellar: :any_skip_relocation, ventura:        "75fa805dcc84bd1ca681943df5480743a97e2b7639b08bf7c05d5e8f7bbfd01a"
    sha256 cellar: :any_skip_relocation, monterey:       "9b24eaf24a8b52f036967f3b7abca4c06bcf2fe6f373dc70ee11d7153531fd10"
    sha256 cellar: :any_skip_relocation, big_sur:        "a395eb3ff08d5927237d3f8123e02d5916e740f943eff9beb3a6d2a039c23f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3406d929846f23c190e40048b7fc1721f9bffbfb0f8bd1d132aa5987e0dadd6e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
