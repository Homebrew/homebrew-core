class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.6.tar.gz"
  sha256 "6d410750eb4ce70db2fa3dc25b7bc33fd4a91a85ef7dff595200d0acef99b1ee"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8131c5791345921e9a18ffaf4f31d5a1e6430c49b39031e964e9f8cc9a25048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37823a58ce5b0ced919ea9253318b4403d06c96154f4dc6e0e76d52ec91667f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "960a4278dbc770631e262c9b280bdf2197cc9e443e6c0b773504d8cb2576dab8"
    sha256 cellar: :any_skip_relocation, ventura:        "73336a4f687524c28f11a0d1d31ed500b16e2cd113b4d5fa59c21c088a2b1749"
    sha256 cellar: :any_skip_relocation, monterey:       "fba1a78ccc3bc1c2047adc9e19fdb323455e8f0a6162a64eb9d2350989c350be"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8d10255dcd08e1fb226b77d81cc35373fbefdb423ca39decc767703bce79368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3649f8cb1a6e129fe4d35557f725c031b9b4539fb6d93c910a4afbba4838b3a7"
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
