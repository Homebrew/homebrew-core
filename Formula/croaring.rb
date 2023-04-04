class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v1.1.0.tar.gz"
  sha256 "b59495578e3e4790a216420ce70578d22c1b6d1987232fc2bf46463a03fb1c06"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe8656eadf500585b19d3a5f60cf350e3c5477fba3341997328842b83fe44e0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93e582e9f711796e8b310d796fb97229ffe457e89ca3963892eebba341bc2a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17146bf74bd46a805ffb0078483a65cb9c529d81b90d45b7719f0c3a8fb4ef51"
    sha256 cellar: :any_skip_relocation, ventura:        "77b3afd7c4a658bf0e320d1c1b95028bc944b79eea20ff657b97d44aebc34121"
    sha256 cellar: :any_skip_relocation, monterey:       "0eb671266e9a50da2726c51c4e1fde9699ac8adf4542b3e14ad102e480ee0084"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0c7df055b293ff90a370fc78079c7819c2045f14e3de911917b9371207fd496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad92891bf616d525bbcefc6e484f1e53e007bb3cdb7a4cc2d6b3b6ba1fdea579"
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
