class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.1.tar.gz"
  sha256 "243f10602b8a321bd3cc44d6474b3f06ce1ae2e67d5c87d683191daf310a18fc"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49677c15b5eadce6c9a6bb8506618ed90a8c495409c1ba2beb12f91a5b5d28c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "738ea46ea5ef8cb60fce0cbe5169eb0990f5e78db3922a9266a72b2ec3f7c24e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b74e0b9afb87b267431ff5002f863bde9378e3284c015b79a1292d5d1e899be"
    sha256 cellar: :any_skip_relocation, ventura:        "866509026c223fbe73c47c09e1850de65a92fe6b51e031aa941947e6a6169fd1"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d4699d249c0c9b058253ee5100a9e658ff844295a05e2f348d769dfe1d1369"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad8fac6ac3acadc2b07235125868fe4a829f2525631840d42e8ae449743beacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde1ae6db8a627b5ddac2beef4da1cbea263b3fb743928789adc3b6eb73dadd6"
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
