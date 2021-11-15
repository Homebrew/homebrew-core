class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.4.0.tar.gz"
  sha256 "0faf6ac893694d5c283a729373af74f813989ef0257781636ac4c397b48c1219"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6148b7ee48a3a5723524e4f918d7da0205df5bfd4025bafe92ecb0a8e78f3e09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e7a0633d5789216b47ed5236431520ae37720cad3818cb96b0a050239e54656"
    sha256 cellar: :any_skip_relocation, monterey:       "7276b52c9cc62874b1319bf0027205ff853c2884ed80956557877a3bbc2464e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4cd03c1f0849065c0ff6e8a55a14fba01fafa1200338945f74f5273e8c05c2"
    sha256 cellar: :any_skip_relocation, catalina:       "0f52b826c8c951829273c69a792007780363c9e0ff874f5e8693e0108786ea94"
    sha256 cellar: :any_skip_relocation, mojave:         "9d81e20356089da75f20d83ff482999f48840a4899bb239de24142fb9e1e1f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93bab19f46526216e3b1d0cf27bde0b9f10811b1de22c17b4bf56df12456ccc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DROARING_BUILD_STATIC=ON", *std_cmake_args
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
