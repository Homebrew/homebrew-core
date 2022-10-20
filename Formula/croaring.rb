class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.7.1.tar.gz"
  sha256 "77faa22b8c1226c9a7bdbca2dbb9c73ea6db9e98db9bfbb6391996cfa7a93d17"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a8ce9e02fb80f493a9d3f9508c0540b5be859d2650344d06fc3cbdde3d6dc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbbc75636ef31fd11d72f66755d27afd1210c462f507061c67b4f5ae8e605544"
    sha256 cellar: :any_skip_relocation, monterey:       "939cbe4d43a0a990c1920bccf8c77e309a34b8c8ec887ea5fecf52f6421efd85"
    sha256 cellar: :any_skip_relocation, big_sur:        "37c86ee614fc151c248eecf33b5fb25f2990c52c858465bd5d910012418f12a6"
    sha256 cellar: :any_skip_relocation, catalina:       "f8d9b2dbf807ad2b899315f9c449a8a8ca1c6c9c46acd3de8ed4e03d5979ba9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9274807fde9ca104914b8a17f90ae262eeeeaccebb797c4b554456cf527ff084"
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
