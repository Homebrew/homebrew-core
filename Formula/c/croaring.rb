class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "56657dab885c3dd1d3ff3b4a795a5ae05cb0a70c0f53d0093b0c281af30aa8ac"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab5ea9c8cb756f51f327388dcf4e1eb468d5b7af1311a7382556fa0d144a27eb"
    sha256 cellar: :any, arm64_sequoia: "0c6545ce9014bbf8804355520bcafeb7cb084a50f743135b70268ea1b4c1d15d"
    sha256 cellar: :any, arm64_sonoma:  "4f3364562d693704950f0c6716b79228ef389b68a52e753723c79f776c7bf849"
    sha256 cellar: :any, sonoma:        "8888aa85c343c7ae1a1036ed9d2a016aeedcdadb714de5887e3237a3db886f6e"
    sha256 cellar: :any, arm64_linux:   "d279c86bd7ee08d4bf81bac00fb9dded5c88e3f1ce97d10276253e5d0a5a964c"
    sha256 cellar: :any, x86_64_linux:  "6f707151d350ff9ce1c9975ebbfa32624732a453e03983d5966dcf5f9a3dfe65"
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
