class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.7.2.tar.gz"
  sha256 "534d7504e648ba4ce8a2e5e0b5416ad4c6d0f5b9d9f23b3849f19118b753dc3e"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb2a8bb4e65f620d753de659f379956b6478fe0d8481fbaacc08fdaf84e075bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25b9d6fccd33630ef95da8773e69c02e5946ade428a080664341c92acb5b283"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c08c6cfe4389fd532b718c7d6e5557df47f5ac15f42a9ba66d9b42d90e2001fb"
    sha256 cellar: :any_skip_relocation, monterey:       "2911cbcfa01cd5652f1e121f5123cfc046ebfb5f11b6bc7e7e8c5801cad32839"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cb6b8c078595196177e81e2443dd71cf58e17477fed13b894b26b57732f1bf3"
    sha256 cellar: :any_skip_relocation, catalina:       "04bf651a1bb7cf8e089b5ad69efc6aaccfe589ba6ceddad3f23928bb4b0ff796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195788cc45e5f9f032c897b314eb51a4764d3a30deb176e5febaa0fa8399ecc6"
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
