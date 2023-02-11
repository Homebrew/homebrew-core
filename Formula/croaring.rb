class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.5.tar.gz"
  sha256 "f4ee9e2bb00411ebcf52751f02b37114e55289e827e8f7beedd36694c30e7f29"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5350a2f071f20769112082f3a7844461ffa5ede5db3aab0a8975ffd61367b568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b839c5a92a6e25e9a6f726962f01651c8794d566a5af5d07100444ea01d24cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aa2a6e82670f2d6bd4231b281a6cf590ae7d7b16baec8d18295641f28fb20ee"
    sha256 cellar: :any_skip_relocation, ventura:        "6a68cfe7eebd5402ed2a95a009dac49d43942e1ee3012cba2732435fbf52826f"
    sha256 cellar: :any_skip_relocation, monterey:       "9c689e84c90c733dd4a4d449092a74be4df4e8cddc6812a1c9b431f064c4ed48"
    sha256 cellar: :any_skip_relocation, big_sur:        "52b0c1fbc29da68271271fe29c6a708dcd4c7903795a4cb216174f431f4e034e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6571f1d4362d9dcbf247fb98e579166bc32569e10d436e14c9a2339499fb0f48"
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
