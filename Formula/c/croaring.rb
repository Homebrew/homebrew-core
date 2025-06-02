class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "7d73ff3286e05cc37fe244a7e7f1bf539c8fdb31e15a883d06bf40b39fb6cf96"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da3280cac7c2a1682db618ade5c8e99e4fe5c7974415af6876e4fae7d42896b6"
    sha256 cellar: :any,                 arm64_sonoma:  "e5e1f34175cdf5e7b288bbd266468295f5b0f4a47dbce3e9e0162b52d788708b"
    sha256 cellar: :any,                 arm64_ventura: "72d5c0e583eef660240c7df8a088e397a367deaefa9a1fa4a46db1c982c64820"
    sha256 cellar: :any,                 sonoma:        "fa987f6fa1b9d0cef284923f610fc9d5f7e21d509313d8072e881811f88396f0"
    sha256 cellar: :any,                 ventura:       "d42071bbe6873d1697c36a6d8bbb95500e369dd8392177d9d312943928c60a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4846d6cc9976612c4455780e844b660481499d3bc91586543d21818ccc06426a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b922f5a7549976baad51b5cec6dbd23d5c21313dce65046a43dd5e51da91ea"
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
