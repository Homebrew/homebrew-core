class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.8.tar.gz"
  sha256 "d83ea18ded541a49f792951a6e71cd20136171ca0a4c15c77ec5cd5b83ca8e63"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "550909327e9731f2b0585f6bbe04d723f81072e0fb09328d5aba86e9f1a11e50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f318b377a36f7deb4ae26586ed0a1659c68423f203d5f6c8813be3a8ed84de0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08dd6bd475f01dbf51dcd861e5e877c05f6aa2551df1499273e9e86bd0833a58"
    sha256 cellar: :any_skip_relocation, ventura:        "b8623db9959bfd9457e480e3c6e26322144d1e86a7b7034a83da464869f8e4f0"
    sha256 cellar: :any_skip_relocation, monterey:       "7d501314a69618c9183b6e621669714e69b2feda2ef6dd85c30e40af1a653afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f56ddf7aab097db32bd11795f513789404df52f25575f721df95a8183d8530ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35d0169902d7460df72b9ddb4eb7329f675faef44b31601507c5cb2422fb015e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_ROARING_TESTS=OFF"
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *std_cmake_args, "-DROARING_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libroaring.a"
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
