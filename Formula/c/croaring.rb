class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "501277ea577614e12fbefe6873d15f94b557cc66ee45240175329abd43fa9762"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33a360100c1c38a32a3ed283fcf4ed6803a108e44c56243d8d87aad058fa325c"
    sha256 cellar: :any, arm64_tahoe:       "dc197836b552052f7774f1a9c0d36323b8460afce25ce34a89e8139d6d4112fe"
    sha256 cellar: :any, arm64_sequoia:     "f359a0dcc65e2eadc14b6280e5fae5e8755e8ecb7556a27d8af7afa09d595c4f"
    sha256 cellar: :any, arm64_linux:       "0970c971120d3afb2cc67655bbf72d52d4dcc85e4b53b157eb1e1f00fe5f862f"
    sha256 cellar: :any, x86_64_linux:      "64cebeb28bf1d1a479f9fa8f8d2c2a3c4c6b91af8b891cb2ce33cc66cd2f2663"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_LTO=ON",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DROARING_USE_CPM=OFF",
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
