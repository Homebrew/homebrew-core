class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "c462698b28dac7a6e36e1e2e391da349838d2e44c8cd17de33b12de737386481"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf8f4de2f4ad967e122876c1e3c72e7dd053357121b96c84e2e537303df29914"
    sha256 cellar: :any, arm64_sequoia: "2e4764a53e7f6914e7fcb45adf5a43af6c04a4068fceea4538d4d9845b550606"
    sha256 cellar: :any, arm64_sonoma:  "280020199977a2203c67def9236fb1a8950254c0814594a9da7b817bf4aa3321"
    sha256 cellar: :any, sonoma:        "0c4a16300c72237e2c435dcf05b4e54b0ef20330c7eaf238c966a2587b55f154"
    sha256 cellar: :any, arm64_linux:   "8a255c4ed19c154219035e65fe33ad6eb87c0360285624f594eaa06474fae355"
    sha256 cellar: :any, x86_64_linux:  "e54c08c99a0d8ebeac551fba8ce69c27c36479ddb1b89b0b9d629a3ce694556c"
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
