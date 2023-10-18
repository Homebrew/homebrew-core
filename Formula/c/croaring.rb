class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v2.0.4.tar.gz"
  sha256 "7e87cae012e80f5cfb4270c1074b807664562bda096124cf68c47cfd99928f83"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "650af5cb67441f3fa1b9b64a8c927f53e6b088ba667992d24ce2f5765fa7a0d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d27d86dae675f63ea20e7dd9ee5d33b9ee0daef478369d42d0f150612ba9c84a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6bceda6b080a12267892bb4a7f211ebe4548c34c7c9f6d36e7b21b7e950c115"
    sha256 cellar: :any_skip_relocation, sonoma:         "396e291aecf6c4bfde9db1ce71a0dc29399875e4af31857244237399db7ac5cd"
    sha256 cellar: :any_skip_relocation, ventura:        "a869fd34fb50ebf8a475530816ea0842c12df0c237ee66260d5c82997b89769c"
    sha256 cellar: :any_skip_relocation, monterey:       "4634a41de5c0a444d5c1675633cd984ab2051da1719b77f171a5993a6116ec0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbfdfc302a37490cdf1ba763e696e7337638060551fc65acb76aa9e67e70b54"
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
