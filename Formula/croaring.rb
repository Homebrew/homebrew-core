class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.4.tar.gz"
  sha256 "55d3c12faea0745046d0d318c9b977db5e58fba09b2a04e48ffb6db4a4e82bea"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b52ea2197858096fa5edb21f50818b6728cdb8612404d96cb190aa1e67b7bb59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7583b8faebce1309f8d88ea2b8d5f1c6bf4823ad2af109c65b124c52f9be10e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f08c8309adf0fe9ae75e2b689259c3f967b310a7c98af8a6752354df121e15e9"
    sha256 cellar: :any_skip_relocation, ventura:        "03d3c379a49646bc0649d31d0cf3772e217f8e88ec29e99697714a2f65e0af17"
    sha256 cellar: :any_skip_relocation, monterey:       "22f231781460fe1240092ab795b9bbdd154f60e02eac83fc30d4c384a9cf6fc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "51186d130a173d142b3e80dde0732b7a5965df415071b1dd565cc7220f7e7a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed96b4854b4aa8e316505bea351fc574750816ffee655d85d6fc4da23890eec5"
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
