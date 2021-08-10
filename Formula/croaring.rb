class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.3.3.tar.gz"
  sha256 "10ae2c0e681bda7a0d3974196d2150cc68beda0fb64b24e87251eaa83d08d07e"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1b036600f5600484b1a1c1efa0a8387c37631d4bfdda337cd5569742d0a9116"
    sha256 cellar: :any_skip_relocation, big_sur:       "9edb29395924e743f0fb0b5ff1f78a870a73c50b593ecdb7261c8dbba4846dfa"
    sha256 cellar: :any_skip_relocation, catalina:      "5c71927ba0c9ebddf7f96300f9ce91811eff6f4e50bcb577f197d2731d2f2b2b"
    sha256 cellar: :any_skip_relocation, mojave:        "93601bbc8c7261ce15a1604d07dc7eb484b20ffe4508ce246fa5c61c98d6d5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4ed4ae52ecd828a0f7abbf495f09f3425741a77c4af7e95ffc08cadf1991c7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DROARING_BUILD_STATIC=ON", *std_cmake_args
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
