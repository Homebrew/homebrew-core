class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.10.tar.gz"
  sha256 "94120b93d7b0509baaafab1b246af4703ba7d4849f082fc2eb7c03c17adb6466"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1dc1f48786bae2f4fd4e47d98d9db66f2852b42ad8221285be646190021a8c90"
    sha256 cellar: :any,                 arm64_sonoma:  "650aba0d8a6d1bb40b3db83dfff2d3c55004de319bdce25f46f868baafe128c8"
    sha256 cellar: :any,                 arm64_ventura: "7b3dc46b6bdd4b0a900187ae5a407bec23739faf09561b0c589d501cd74bf01c"
    sha256 cellar: :any,                 sonoma:        "ae0652cd60b56b153600249ba9445b084a31befd5ee17744977fd45cfff1d130"
    sha256 cellar: :any,                 ventura:       "a8bc625a7e96d28b70daf1ed00676c290c389cfbccbbe4a3aac59ef8730cd30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94c8f998fa11e7092d8c3cd4afd647ab4ab7f3ae9ac6ec029db0c7d084bf7ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edba25bf8ea24fd8421f8d0fac9e2a4d3ffa9affed3c5704a1ba247f51fd71d3"
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
