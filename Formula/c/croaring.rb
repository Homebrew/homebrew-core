class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "75e2c106bf3c035f92560017b56b01602744b643a3fef08d69255c138c6c6f5c"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9195962c500c3c2fff309b81f0d5044f6baf3146b1f133440834f31a6da2f17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f80b51b4c106ab2bd0197ac7e15fb851c71d3db8815b44dd41d0aab0641aea4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e912f99ab4fa3a6a81c3cd7099ccf6d076090eb4cae1e2c2408347505c8acf1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e8998b35d320fb8c32e9cf2d34ecde2406fd8d2467bdbaa7cbac0509cc94943"
    sha256 cellar: :any_skip_relocation, ventura:        "99d3b3d93c7cdcf35dd0d56453cc75c3421123c8557c816025f743a506d4cbe5"
    sha256 cellar: :any_skip_relocation, monterey:       "7dd805da4faeb7e6455fa92e58f3403a5e3a15b002475fcd58eb8d7e67bf205f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60365db5aa7bc236d476ee5f78e74586f99f62754d7ef56fc86e333a3ccdb77b"
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
