class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "42804cc2bb5c9279ec4fcaa56d2d6b389da934634abcce8dbc4e4c1d60e1468d"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e424051e9e0e52bcf952593cd59102f7c5e18f0f038a5507cd109f446d66ed03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03b989b2e8fc22a415bc6caa7d2f0a890fe2e65a83dbc9c5ad5b00c71de8181c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20834ebba79162f720f03d5a6ac191df683014b849eb089388357fc9734bc469"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8d64ce7834497f49316e1b123400dabeb9bfcf4c9e6f1eb6c20dadbf33eae69"
    sha256 cellar: :any_skip_relocation, ventura:        "3135ffc446b7cc49a3285276b582e4776058840c98f96d5a7171c15b80aad82a"
    sha256 cellar: :any_skip_relocation, monterey:       "9b87c10de153acb4057db40784a904daa80f09c8ecf6d725d361fd6a6336cefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "098bf3c479ff74027b2517568d9879afd3dc231a7bac84159aea196395bff43f"
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
