class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.6.0.tar.gz"
  sha256 "b8e2499ca9ac6ba0d18dbbcde4bae3752acf81f08ea6309ea2a88d27972dffcf"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976461ff2b4345eb64b086730e252875d4fcdf52bd7706b12d13de87f0df0a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12bef7b04eddf5984118ef09960685ed2e14829a097842aaf5980a6789400158"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad9202dd910f30b9bb5026be035cf6e1806f3b9b0617b9a4f75db0f921d8aa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4715c7560377aedf592a249faa4393cfbbb6afdafa957e951a2260ec4d208894"
    sha256 cellar: :any_skip_relocation, catalina:       "6fa926f943b72826c38e44521aeb8786c74d5e8c4c59e3454be4c1ea7a93e6b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e367c1e1caf5edef758ddf3f56e161e5241b98ae1cf5e7b596098ac9c49ba6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_ROARING_TESTS=OFF"
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *std_cmake_args, "-DROARING_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libroaring.a"
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
