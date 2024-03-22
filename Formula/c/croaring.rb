class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "25183bc54ab650d964256d547869a34573a13d06f7e6a369b79e77f5c1feb8ba"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7326a6f5dae8c74d50a7d84efc7e8e47f1c0b86bf8771d4ca804d95a989c6036"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7fbdc0a25f949e10cba05bf2ba1b3b48b8825a84b24a1759fbc76bc67a00f51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00bda1792048e52e49084eb3f48ded53a1f38ffbc22aa2a645767632719b3086"
    sha256 cellar: :any_skip_relocation, sonoma:         "8805106f696217bf0bd1e56af64c775412a44c9daeef8f7166d4ce46cb5e8319"
    sha256 cellar: :any_skip_relocation, ventura:        "7e32d2ba5309419ed18dac0cad58637141facf20864b3d53ce003716a7ab579c"
    sha256 cellar: :any_skip_relocation, monterey:       "8cbc00fc63d77cee00124656e26a4add5852a669ebce251e81c2064b25ed7d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce7dcd2735ec40c9b77354d19f7990aba1ce33f8e894e91c52813c247ca6deb"
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
