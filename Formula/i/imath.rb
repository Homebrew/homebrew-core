class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.11.tar.gz"
  sha256 "9057849585e49b8b85abe7cc1e76e22963b01bfdc3b6d83eac90c499cd760063"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cffec79d68d6577853e7c5328989443d753889688248802e2abadca4e09aa88"
    sha256 cellar: :any,                 arm64_ventura:  "82dadfb3bbfa4c9305c0f289ad13475b5205acd8394ea13c2880458abb0465d5"
    sha256 cellar: :any,                 arm64_monterey: "fbc0023344b0fc0a5b37255dc2609c63fdc558635bffe99cb4a1edec17bb5f5d"
    sha256 cellar: :any,                 sonoma:         "12cb616c568e6f88de3308da46672b100a262a855546b1e224b0b3ad94a07dc2"
    sha256 cellar: :any,                 ventura:        "9e92fa7fa7f2803cfa73838d963fab399c0e88012fdde0a5fd32c7cbff089b37"
    sha256 cellar: :any,                 monterey:       "a623aab5fd0f29c3404058db5f6efbb71c057f09cad4e4487c0b996314e84498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c405f3c1093df42aa82c2e2da39ed9b83ce0f7569864ec56560e2851c788bedf"
  end

  depends_on "cmake" => :build

  # These used to be provided by `ilmbase`
  link_overwrite "lib/libImath.dylib"
  link_overwrite "lib/libImath.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}/Imath", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
