class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v1.0.0.tar.gz"
  sha256 "08f884cd2790fcfba69b63443442034702f5d4865514fb09ac6ff05e048bf230"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9b6e089af19f351720a2f6ecc85feb860051967e8e4f07c9fd22305c1ecc40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d553669f24523259960cb6b75de90e47606bd96a48ea828bd460fc8a8e07b645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f603b8c10f6d3fed0eacde22233faaa2cff36485e7b31d22288bf2c64ecdab3c"
    sha256 cellar: :any_skip_relocation, ventura:        "9f58a51b97f42241348670ab223bbe029b02ea8022e423579f9ee5de9e4d13cf"
    sha256 cellar: :any_skip_relocation, monterey:       "dfeaa3bc54b8e4e6c70ae611992d6ec594b9e96ceed4507208710ca6bec7d050"
    sha256 cellar: :any_skip_relocation, big_sur:        "70bc0fdde23883824629784b5d648391870cf22226d516539da9e931d5c8bb68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c3bf054c8a500e579ee6894634d0133729df46f51b5ab04d2dcc26aa363668"
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
