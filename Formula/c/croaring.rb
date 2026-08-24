class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "81ea587c658bf7ba3394fa1bc0a3847e24f77228cb7d7df6f54c22244b346772"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca7645c7ea67f75103a01cad51d6914d14139a7a2ce39ef56d10baa4d2bb4925"
    sha256 cellar: :any, arm64_sequoia: "62e1be7da27d102e774b55881ac8906794e0c58d1323c0c0a3fd9884b73eebd1"
    sha256 cellar: :any, arm64_sonoma:  "4811355538c8bcce3a06cdcde280b8fd0fa19ae2c1a483966f9cab3d8b6b1cb7"
    sha256 cellar: :any, sonoma:        "e998b946ee47e3ef70249253a11146afb401ca7c0c70eba6357aa85f1497c5e3"
    sha256 cellar: :any, arm64_linux:   "c5b334cdb89b2f542beea6d83f88f1db9c1cf1c1d04ced18d8c7bec580487de8"
    sha256 cellar: :any, x86_64_linux:  "8ee9f12d5de9829d93ea25e76a378acafaa5ec5f6dc20bbbac4427e4a0679298"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DROARING_BUILD_LTO=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
