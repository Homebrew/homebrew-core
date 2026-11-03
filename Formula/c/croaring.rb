class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "501277ea577614e12fbefe6873d15f94b557cc66ee45240175329abd43fa9762"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08e8fa503cbc4a0aa7d6653498eddb4b50ae889aa8bdc72412c601ff972c48a8"
    sha256 cellar: :any, arm64_tahoe:       "c34949f41ee6f49183fc0623153d31d3fbc2cc15f8f20102bb4c9e6397016fdf"
    sha256 cellar: :any, arm64_sequoia:     "ef102974d095395151125789b395837a76f92e9fad91ddd1be74887b4b4f6495"
    sha256 cellar: :any, arm64_linux:       "74867bcf9bfd95305d4db1f439e9d09de176f8212ef193344058db1a2fee9e6f"
    sha256 cellar: :any, x86_64_linux:      "862772290a93634cba8503772d09b7af249d7d5fa4ec82649cee521b27404b86"
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
