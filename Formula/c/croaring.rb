class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "a8b98db3800cd10979561a1388e4e970886a24015bd6cfabb08ba7917f541b0d"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86ad151c65678b4cd588a0b4d6a1e0e14e88f5bc326961e422ec937f6f11702d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaadc9a3488b2a61b227c9996cc45ee71f1f64d9562532f5ab08c067a8e06841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db617104ce0324f941cd014e5fc8e97becefc456cc561b7f012e6cf0992803ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "078067eb4f50bdde25a8c1ea5399bccb08b7106a05fac2d3b271006746ce4949"
    sha256 cellar: :any_skip_relocation, ventura:        "7333a44dc08190aaf37f0099e0024e35a4700389bc6c0d6b130ccee6a07502d6"
    sha256 cellar: :any_skip_relocation, monterey:       "fba772bbe82c70e8a5c2da76dfb5d688e4044ccc9ec217b439fa1dc67c6734b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e2b4d856d97f24aa02e7b4c23ffb4dbb08fdf562bed19fa1d0235101283c668"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
