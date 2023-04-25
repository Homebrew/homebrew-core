class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v1.1.2.tar.gz"
  sha256 "545fab4f00d946000743c563b3c315c1a11cee1f19c6ba4fb9493824a4e68b9a"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c3cb429b3806b6fa0d13d7e1d94237b98fa8a6ef7d1097f650508cfab52203"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a099c04b7355db6cd71ccbb8f09b6952503ced60e976e8fb467f2553702561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b07c5e70fc87934df0c25d18ee598b7836e896d090a91689164596ca5190f5ab"
    sha256 cellar: :any_skip_relocation, ventura:        "e3f04cf4704d1862040654ef73ecec3eb9bf4b29a7aa70397bb302228713837f"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ad19816231502560d6202898233150fc020809b90f8c6d7b277ba2132437e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "33ea2b712028be90eed527147b62be9f9b57c76f5f9f72d52839fcb7fd640ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0155f11e90f3c6a416d88b9019e6da5d98f75daff107a01df16649f6110cf220"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
