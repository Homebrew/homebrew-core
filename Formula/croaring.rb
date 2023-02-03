class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.2.tar.gz"
  sha256 "30c927d718726ea3f6399b0f92071566ebbbafca2c5a560b2610cc0baf78ba74"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e862c01349edd35f62d7839abf4b44403f5ab209bc0a911f1d49d83d09f3ce53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecf3dfbffdaf8f68f1a9842562d344de0c169595fbec7052219e1b763a9e8e64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bffb9e6ffeb7cb5aa5b7819ed06c75fd5b1c8e0905d572d348f9ccd087b3992"
    sha256 cellar: :any_skip_relocation, ventura:        "f9d03c5d013f2132694bbb369365ca695bc8d63d80e2f20c2eac6b325c1fb98e"
    sha256 cellar: :any_skip_relocation, monterey:       "a7fadbfe373d3c1f13b0c5268ccbfb4d07e7292ec861e883516c3ccec8f21c9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3717561fecff19000e111c4eb1adb6549036b9ebb0a5338b1a46b8cdee3c8c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c7845c15fcdf521e44f6deca1dcdcd7302af337e09c5092e49d54428074e832"
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
