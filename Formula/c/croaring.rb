class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.7.2.tar.gz"
  sha256 "3695a0aac3e8b6f2fd3ec45151a5fb7c28b432538777b7b7473de3b83f088960"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba21ef431ba2f4552dd68c4b90b61e8c575cb6e54e9859596d182b96c322d689"
    sha256 cellar: :any, arm64_sequoia: "1a67a8c81e02422e6f7c05c28af4cd333dc8cd473c8d5c76a8c9ea303f97d677"
    sha256 cellar: :any, arm64_sonoma:  "f4fdc2488e1150c41386c010dfc77be4c3c92512d3885c8412001e7aadad9c95"
    sha256 cellar: :any, sonoma:        "9eff0f1f62e374f2861502ffc51f25507d46fbe80887c4c86e3f9aa1f7c2daf1"
    sha256 cellar: :any, arm64_linux:   "ebadc231ae43aa822ac3211d6e50f3bace4ae7bd07308f89a29bda2ddcba82dc"
    sha256 cellar: :any, x86_64_linux:  "18e26fdc19d0f24ca4e793711c90d5b4619f3f31c331ea97a0b81e8d058da15c"
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
