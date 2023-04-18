class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v1.1.1.tar.gz"
  sha256 "b47608d6809fcb973f8ea440a3ad867347842da907f5e9762e25cc5248f0e850"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0d55d28430b00b559bd7136e18ec157b823bdaca88e5b4f367938f3e99cbc5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b01438e9f913c26bf9a5f1419ef8b9b94aa36ff826655c925a71da66d50f35a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a63a2f6fb6f65f63929d7c7a809e56bfacb73ea13549e47f6499f4f174c94fe"
    sha256 cellar: :any_skip_relocation, ventura:        "c778bef3519c289bf8b27b279962a68824a5d34ed3bac7a030016807259c10ba"
    sha256 cellar: :any_skip_relocation, monterey:       "82ed27834a40263c821b951ef019c29400d2b743d4516188f6dd209f57c5546f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba630684fdbed9792a499d22d2a4744e92115bc173e7a00aefbefbdb8079bf10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc729d0e0e0ab4da6d2dc3a1853046e69cfb430c0221ccdbe411c121a8cb641"
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
