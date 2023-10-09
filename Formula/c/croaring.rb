class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v2.0.3.tar.gz"
  sha256 "3e6c66ba63e6b8facffa99749c76f0d616fa152b6f649a6e8a1dfa4450d51620"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf8b26f20e7dab520917dbc2d456ea100b48170dcbbb184f44e5895a249dd6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5877326a9e12ffdd3abb8f99d858a7d502f1b7b7433c0912698906ce85077b74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04d42cb4250606d799ff4ba55d035777b36778ce82df4dff4b1ba5e8f0eb2874"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb26222be32750e53864284cfe259e4f3313fffee99154ac9a1866929c0eb875"
    sha256 cellar: :any_skip_relocation, ventura:        "55b6b36a22430c932d5dc6423ce384df2b78d458142557825992c949d6a578f2"
    sha256 cellar: :any_skip_relocation, monterey:       "864f57441a6baa44ae24b2d1af1dea7ea944858e92e3aa4c9a8a59c0593c558f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef9f55a253dc4208ebdcd548689198a310b33ff705c38b019f772c4ea6302a34"
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
