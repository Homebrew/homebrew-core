class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "5fd485bfdb83261143e6d0ad8967bf779cf99eda6747ac198d861f3b8e4a1e46"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ee8719bf1769488cae0e8e6c31292b4e52f65a07d2fd18307417c6f39f26407"
    sha256 cellar: :any,                 arm64_sequoia: "f1c560aa56fd1551a942192277672b18212eedf950775fa40700c46be361da74"
    sha256 cellar: :any,                 arm64_sonoma:  "edb5787dd7460788c57a0d17af647d6e717a0fb8b4fc266d323872111cab463f"
    sha256 cellar: :any,                 sonoma:        "3f5197251c9427e0f8f43209663d988e811b7dd40504cdeb42e19058cdd6def6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c608a9160fff05ef3241f4429d2bc5d5dc2763a9fb30b77265f43ea979c5d851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fdf0b7b59640c136e80b0083f33da3bac92c8aad52df7caa46c6c30610a4376"
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
