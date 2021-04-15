class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.3.1.tar.gz"
  sha256 "ec957f2d738b3c354e76cdeb39d2bd61662bcc0dd432c1d3cd31b7e2f101a37e"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57e5e5d947cd1e8f80e9f1efc689ad0318cce9550200e49d2658ce02036604e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebea156039a3e6c492587169b7cc99888f23c685b6c628ee1f9528cfc12612f5"
    sha256 cellar: :any_skip_relocation, catalina:      "9992c65ddb9f441596c980a9934d95ac98e28ff5847c6070ca866b31d59355b0"
    sha256 cellar: :any_skip_relocation, mojave:        "ab1186abca985af61bd8a915886d2a06b59597071503e9bdd55fa48de81caa40"
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
