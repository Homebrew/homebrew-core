class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "73dd38565ab68c210d72d80bf13eebaf01431950b8d74b8dd0f2e82170c0ccdb"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14b2ca81622f77e229e11ef55f9ff4cd8a70146529dc90cc5b8b4c6b629c55b9"
    sha256 cellar: :any,                 arm64_sequoia: "0de651bf807854274b0979566a02e73398c19c0b345404994f5e689ab113d1ce"
    sha256 cellar: :any,                 arm64_sonoma:  "8a3591b7d63284b258f7c499bb294b6648ea40afb78d39c45f1c2258f8210c5c"
    sha256 cellar: :any,                 sonoma:        "714987e92ee61631217cf6ae04952344eb1e47c3e14afe6e93339a408980ea8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef61186a6dcbb1df95dc2a0a3eece4bbe56e554fdab9f80bdeddfb24970bddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e96fd7ec995eb46eedfc7031cfac0c785068646fcb04ca278d794393e08ffa"
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
