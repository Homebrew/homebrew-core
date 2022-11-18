class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.8.0.tar.gz"
  sha256 "cd6c4770baccfea385c0c6891a8a80133ba26093209740ca0a3eea348aff1a20"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "021240697caef9702fe29dd2bb51ff728558711a2f9807ad9c4373df72f2fe64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848dd7a378d3ab3cabe260b456d91ff2be1d7224db4c7cae580677ba755d2362"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0686aa5b5cf79cc63a7c24954ae7b0f13007c9803f0e7890d840e9032c3905b"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe214698ad3477c52cad70524c60639b3598e3f1ee64347be68e8631f2ee6b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2659f0dbf6070f4c84cce6c6be52276ba3de80e6bf275a536a0d5f0d23323a66"
    sha256 cellar: :any_skip_relocation, catalina:       "73ab63a364fbb0da2dc47ebe680ed600f7b0d29ff499206912d2eec307c43ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a69b7cf6b295bf393e4d33c27b602f2fbef055cc7240642328e744f70244694"
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
