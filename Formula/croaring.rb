class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.9.3.tar.gz"
  sha256 "b7534adebf50a554e86b81a2b39459c9921c504e9a876abe00bd741d0a4bc85d"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cd0268d7b60c3ed2d1c98b1d1c509fa8e87d1ae6f3b01dd64474f01d72a3a30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7872c0f10366a2f2be71b1c41422972d575e8e364cd97105610b553dc1446e4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f152b3d8de547d47e138c67bad18167662b6f38529afb8603c6d93b2352dc1c"
    sha256 cellar: :any_skip_relocation, ventura:        "7a2a060e7540966d3a1effc036f535a227bcd491f9d32880074d19c7c2a8d5a1"
    sha256 cellar: :any_skip_relocation, monterey:       "2ab3f2eb63153b53c64bc45622636cc08cb392698dc1b1522e7f922e2f70db0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a51b5a13917b80af46076ed5588bbce5c3aa7ae0a798aa163c74c566a591f44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0c14d49afdbfc229b403470835cde6be8512493a984befc2dfe5b3e60de2e9"
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
