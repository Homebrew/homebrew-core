class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "25183bc54ab650d964256d547869a34573a13d06f7e6a369b79e77f5c1feb8ba"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f91a966e57f5f25f4f2ed6deccbec21af73d1dd8a5fb4e23f4b92cd127694bec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5add8274ab0235fb2f8f3ed0e7728e06369685e06e6c123e3debb8fab21eba6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8867be0c3844c4f4522e030c02fb19df9b6d958a577469581d21b62884f9ed0"
    sha256 cellar: :any_skip_relocation, sonoma:         "af587f1a6e67dd2e137345df5945e54b3b1bf516c854cd4907500d6eadce18f9"
    sha256 cellar: :any_skip_relocation, ventura:        "d2399369aed447881753377bc2ea2f711a0f0b8100825530bce05ed557a6a2a4"
    sha256 cellar: :any_skip_relocation, monterey:       "fd797c40152b58ac85267f84bc1621a0ec56a5d1d4d294beeffa5af6c850c384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732c32acdf20fea408a5942d0a0caf9a9e87cb1b8b052925e6ed93301134a9a6"
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
