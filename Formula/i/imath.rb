class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://imath.readthedocs.io/en/latest/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "b2c8a44c3e4695b74e9644c76f5f5480767355c6f98cde58ba0e82b4ad8c63ce"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9651c2e6be0319635e32871113b62114ed28e6d02909cb9a20a5d270eb50a1cd"
    sha256 cellar: :any,                 arm64_sequoia: "ee09da9303b9bf3adfc1914072e168e4ea26d951a04f382085bd536950cbfe38"
    sha256 cellar: :any,                 arm64_sonoma:  "3c7b6425f73e3bba7545e6623936388294f5f8d66594475477e17edb8afc7406"
    sha256 cellar: :any,                 arm64_ventura: "2b5ec21503c88bf54ffaae924922c69a270f3a9cda382714d2f03b2fe51e866c"
    sha256 cellar: :any,                 sonoma:        "c2673b472af5299c359c6d8b7a2fa664b9289b1ecb69e29123a64914bbfef205"
    sha256 cellar: :any,                 ventura:       "1105716a3869feae8ce50c2ccd20f9d17ccd8e4b970a66a27368d0cca659ca69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742a6635170ab0b122a7916d592c92b83e50ae01211a55eedd2603ed069e417b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f821e8883e12443a2487cb177cea3aa4a3092cae5212b8623f40d8c5027605d3"
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
