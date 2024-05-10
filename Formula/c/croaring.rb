class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "a1cac9489b1c806c5594073e5db36475e247604282a47b650f4166c185ab061f"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67ecddbca0e59eba8a167fead7f9db12466326fac3bb5d14fd2e008fe93478f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76cb0304a6b6e336b2ebb46155833a45fdae9e916235879d83e63360d440d8a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16d88ec3b1fab99e32a488ef2e2989078dd39acb1fb78919e5c24b9b61697eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb7b33e85a2d759733c5544dd47c328e81653e14334e212c4ce3661f93ce47d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ee92219e227cc16abbad2fb2beddaae84e1509f8a441a842c53394043b9cc79d"
    sha256 cellar: :any_skip_relocation, monterey:       "409363193d398729b66e3c47c798ffad6c1e3b53194900b1f3909953a081da5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ffea077da1e7bd3a20ec8646becf2ecef45ac2d2c51a2825420f15291053851"
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
