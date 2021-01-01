class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with openexr.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.4.tar.gz"
  sha256 "dba19e9c6720c6f64fbc8b9d1867eaa75da6438109b941eefdc75ed141b6576d"
  license "BSD-3-Clause"

  bottle do
    sha256 "2d5ac295eca0406b65a50fba2ffe68b3ac4d384b1b10fbd0ec6ec61cd0b67491" => :big_sur
    sha256 "11ff105078dfbd0dd2d6a39aa3f41e2dcc342774ee8ebcd74bbc90d0feae6197" => :arm64_big_sur
    sha256 "06a9f5b4582372750cf8fb6ba67d65284b00c6c338fc037a363ef9d550c5a9d2" => :catalina
    sha256 "5cb7f4e1e07f02aba93615d1ef1ec6785a5d868cad642460b2d2871cde3fc08a" => :mojave
    sha256 "30cea2bd30d5fd3baae5188b0e98d065f78070b741b367b2cdd22b7a7e0269be" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
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
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
