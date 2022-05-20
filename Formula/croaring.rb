class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.5.0.tar.gz"
  sha256 "edab1b1a464e5a361ff622dc833170b2f33729c161aee4c2e53a324ac62ef78f"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "613062d7b85f53b9acf9c99a459217cd807c3e6fc9294ce4c871a56c17ba983b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c68f8e1077e62ce292416ecc278c07a9b833c654c6ce6601cc6efaf2f94acec"
    sha256 cellar: :any_skip_relocation, monterey:       "f59810c10d85550d85889f74735eaff72e3bb8e262c5389abd8477ce1cd779f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "50802f55188c5bcfa6c4addbe339405c406aab1c65644189207464cfe51f9fa6"
    sha256 cellar: :any_skip_relocation, catalina:       "b22a7a363ac1365a37d1aa949c80c76dae22c187ea2fa415b206c360f5d95492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7235f4b4dcbfde67214a61a32c3795eee3cb76a110722045c40c8ce66631ed9"
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
