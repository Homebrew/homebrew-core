class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "3514728e9eb8c90dbc00a9e337302eb458c65be2f9501a3e882d051599c4a74c"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e974350f88d48b01a67889db048adc10afedc58b30bbd7b0ff1713caa5e3593e"
    sha256 cellar: :any,                 arm64_sonoma:  "ddc34aa730264ea9dd5888b5ad4921d274b689800b8f7d34d92e88ff49b3e23a"
    sha256 cellar: :any,                 arm64_ventura: "37cdf56f107ffce5f8e057ed7af3e3fccc858cba7186a8a34245baccc8e83d81"
    sha256 cellar: :any,                 sonoma:        "7d80e56d7ddac82b599a7294d46675be1ba649551512df0d1f3ae83b91d52457"
    sha256 cellar: :any,                 ventura:       "5edef7cff1281ddf4bad1334417073a514072c1e927a319f280bcd298e2e7480"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d7133a9ff1cc475fb901116c344424df59b73f396de49804da23b72a37db6a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DROARING_BUILD_LTO=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
