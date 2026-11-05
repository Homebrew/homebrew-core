class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v5.5.5.tar.gz"
  sha256 "f78a93b8cf373fe4a3d31075cf2b3dc21dcfd7bbbc17674df35071ec8e461aef"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aa25fc1178d54edcd5d0cc846882f8ec8dc6df3f2ce263aaecc53858b33feffc"
    sha256 cellar: :any, arm64_tahoe:       "45f0571e632ee31cd543a7a1e6266aae3ba28b588abb4a60c44cd9173743897a"
    sha256 cellar: :any, arm64_sequoia:     "1569c2cec24e858e51dac303adf97e04ef18c641a221ff09afdb1a264e916fc6"
    sha256 cellar: :any, arm64_linux:       "13479cb848fd8f1966e831ffe9a7c2d9e54ff4f5d0b05e6907bc051451b20ec1"
    sha256 cellar: :any, x86_64_linux:      "225fe434607b451e1e838135112be59960b4d5c9d7c1a808884ac1795bdafcd2"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_ROARING_TESTS=OFF",
                    "-DROARING_BUILD_LTO=ON",
                    "-DROARING_BUILD_STATIC=OFF",
                    "-DROARING_USE_CPM=OFF",
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
