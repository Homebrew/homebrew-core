class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.1.tar.gz"
  sha256 "11f806bf256453e39fc33bd1cf1fa576a54f144cedcdd3e6935a177e5a89d02e"

  bottle do
    sha256 "4748d38413303488484f98d5fbb94bb90a3f2e6a7fc9830fe5ce12463ef6812b" => :catalina
    sha256 "c3645960e26293a38a9ed68996c21f9bdd00bf138c66a187d97b3be9a6f63247" => :mojave
    sha256 "833b56397ee633635ae29f4b7c5f526590038cdda44bf1250fbee59bbada4013" => :high_sierra
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
