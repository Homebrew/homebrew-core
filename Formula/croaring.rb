class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.7.1.tar.gz"
  sha256 "77faa22b8c1226c9a7bdbca2dbb9c73ea6db9e98db9bfbb6391996cfa7a93d17"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42d6d258cfd85f03941345f8aee3505d4ee4c3075e10654de214b9ce7e5f12b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "077a2559fca0809308cc06469a43ea21506ea0d032494ada07e2fa6bf2bdbb4a"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5f99d8cdaf4cffdf35405f42012adc6f8b36ced7001d11fadf2077a97f33a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6536e2ec93e4ffdbf9af269a78daee4b463582aaf4f76a5594f253fa03e6f686"
    sha256 cellar: :any_skip_relocation, catalina:       "829e9460a01ca37d16e2bad3dce1afcaebbaa487efd7ba56a1c06b2d28c3b904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bee0cd5b50a7e9562050c1d4a9f6aea9de4a2ef84046c43a81dee94ee8a8e09"
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
