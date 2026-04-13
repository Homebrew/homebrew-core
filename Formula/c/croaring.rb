class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.6.1.tar.gz"
  sha256 "f9240cd0597f9918aab476cbc6b64c114f89ce296b2baf79c208142cfbd3cbc5"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bf56ec536ebc324a3ae372b6bb2a9b8903449378bc9c363f3e593b053853bcc"
    sha256 cellar: :any,                 arm64_sequoia: "dca6abb65c96d86056811bcfd2fceb2cf0995f77af5b53cd0577047c0fd629e7"
    sha256 cellar: :any,                 arm64_sonoma:  "c3b926e7c8bf952f366424a4e6b33b9c9388e11a2bed3bfc2d45944445eb1554"
    sha256 cellar: :any,                 sonoma:        "ab44677bf63933958a9aa731c580c1b1285cac7187abe506eb7e1f1a35ad1524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c85cbaf48a9a7592ab197f9ec348702c41acd64a26b328307821928f05a1506e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61975f10d358f2a3769596d1c7cab5076b1db47a05694e71b4e00ff96008e9aa"
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
