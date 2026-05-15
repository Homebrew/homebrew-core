class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "ddf61da01627904f5277becf833568b26853203e74292bebb90f49dc093adf02"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a43a5d4609afe83c3b339a8a5e5046b6c0273489a85489aca5e57e4aaba4a51"
    sha256 cellar: :any,                 arm64_sequoia: "e9198f79e47570718ddf16a597fcedf846247a1b7ec12169a998e1f153067b04"
    sha256 cellar: :any,                 arm64_sonoma:  "7e6707e670099176a200b1a0a0275dd5f7069e815f23c319b6b305d58c986de9"
    sha256 cellar: :any,                 sonoma:        "1cd5277112464972e104c6fe4460618f6ad5ccea8b4b55fbe6a72721dffede4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7dbca4e94c867a0e98a849c685fb8dd33e672df63dfdb974d3924e020b95695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edeab600d099d63b0c160c49471ae9f18f108640cc6a1d8b524c9f860544ef74"
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
