class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.9.tar.gz"
  sha256 "3083bcbc37e43403111c482ddf317a710972256c23bc83abc8925803a02bdf60"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c52d0a667c1dc5427d3bc110b6cdbc2c5b98175d8e3d596d675012dd6c1ddc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee5d336c599906f60117e504cdda438bb09cbd402b742e13729d63df4c1d369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78603b7161a4268c10548e5e35d3f39763d002e6f82c1eb08e74c1e3892403c4"
    sha256 cellar: :any_skip_relocation, ventura:        "eb6031a9d7e51694616d73b61044a8923a3967ea4af265acae6c46ffdb77b672"
    sha256 cellar: :any_skip_relocation, monterey:       "9b9cf4ba4ecab2c4d3ffddde1b46194e58c52b33ca6b8347197e948c28bd1f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c424d6cbbaf9d11624a90541f10811e10161aa986cc57dbcd6af88ca5f317dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8116192a13c508707661cafba62867e7bf7cddca9f01edc9765788aa6e21cb3e"
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
