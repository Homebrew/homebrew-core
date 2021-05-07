class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with openexr.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.5.tar.gz"
  sha256 "59e98361cb31456a9634378d0f653a2b9554b8900f233450f2396ff495ea76b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "f465c8e3f824777ab727d17e11c018eff8d8afc12ffe0bb014dbce22522e9b7d"
    sha256 big_sur:       "c29c6544af5a4b57b14984322b16ab1d7e5e6598f6a999bed1cd757b78d8324c"
    sha256 catalina:      "9f185fa9c393f463d37002736f4ef0dfdbe347a60193d38371d1b1055fc22a0d"
    sha256 mojave:        "53b8f2f3e3e1ef9b6c22de5993eec29ab6d9cc46109df39a7eb7b49f0b8e02a2"
  end

  keg_only "ilmbase conflicts with `openexr` and `imath`"

  # https://github.com/AcademySoftwareFoundation/openexr/pull/929
  deprecate! date: "2021-04-05", because: :unsupported

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
