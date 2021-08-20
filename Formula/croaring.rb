class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.3.4.tar.gz"
  sha256 "ddc5899823c46707d7dbf4e4c117a811b0428bdcb84978d9e65ceaefe6f59595"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48c13771996920e1fe157a567214cad04e6c2203924abbe3edad98ff508f59c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "42b53f3ac6cd38ee432160d6b4e6d083e90066fcc87bfc21258bcaaff55f9549"
    sha256 cellar: :any_skip_relocation, catalina:      "a2d778ec914fe0ddc0ee913e73719c1ec2f63a2e967b6afd0f5dabc9c7b1842e"
    sha256 cellar: :any_skip_relocation, mojave:        "5292b2a36e51944a724d01f04ad0f6fdec9b6f0b2c9a96cdeb2ca04e963425ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ef5319a55fcc9bfe95fe033b2ddcf6368aeb4577016d624a267908c7e64b48"
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
