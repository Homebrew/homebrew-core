class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.3.1.tar.gz"
  sha256 "ec957f2d738b3c354e76cdeb39d2bd61662bcc0dd432c1d3cd31b7e2f101a37e"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b9b5a2a974922065b6532dee72f1d0eef18d0acc974d140b341c357c6d22e68"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fb31a81cdf29a48b64c2145e22a7807fbeef260b90ebfb33b69792e600d1a91"
    sha256 cellar: :any_skip_relocation, catalina:      "876be0d01194b15d750d331d6aa3ca38600e0c027892bd665417cd8e9ae5ebf0"
    sha256 cellar: :any_skip_relocation, mojave:        "1e3f2c5daacd9fa4a9895b4cd989b5d3443884e6db0a854491759c5464a1ae1e"
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
