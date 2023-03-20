class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.9.tar.gz"
  sha256 "3083bcbc37e43403111c482ddf317a710972256c23bc83abc8925803a02bdf60"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8a182124d0898592abe0123b22d1edfb3f0626bfbd587cd07aca21fedb91902"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63450710e4cd6785b09d147f2aaf423327cc5b9f91166807730d8f362a57345a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75f273624bb867cdb1f9762c14a2cfed04bd03889d7ad4312577c1630cc8d4ec"
    sha256 cellar: :any_skip_relocation, ventura:        "d6194284d0c9220e6e3478d103d6d5f797938a40d2ca0ba8fe46ac2dbbc3a975"
    sha256 cellar: :any_skip_relocation, monterey:       "44f3d875ceed35c02a4e9676aa3f920cebad8c4021282e3473f6ddc2827d836c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5eda8483dad25c6d512ea8ea7a2272c0561affaa24eca16ac4327e3f2ce01da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "addd787a98e30a5419ff4eac757601e813d9ed7cc68c5b679c58ea53ac2343de"
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
