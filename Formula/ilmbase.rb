class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.1.tar.gz"
  sha256 "11f806bf256453e39fc33bd1cf1fa576a54f144cedcdd3e6935a177e5a89d02e"

  bottle do
    rebuild 1
    sha256 "77fa3ade193f751b7301feae07da4f801adf693ddba02915778c77d142f03311" => :catalina
    sha256 "26209d6086178373e08d8ca6f5acf1c3b49e6896e1fa4eff0c06a3bd91f7b550" => :mojave
    sha256 "9d141246fae66f97b71e864f2c8b7264d5f317380f3872017dc52ea1efd3ea3d" => :high_sierra
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
