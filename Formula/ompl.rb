class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.0.tar.gz"
  sha256 "a7df8611b7823ef44c731f02897571adfc23551e85c6618d926e7720004267a5"
  head "https://github.com/ompl/ompl.git"

  bottle do
    rebuild 1
    sha256 "9402582e9dba3b47fb91bd36dec50086fd36effaf4cf5734c44c4d71362729eb" => :catalina
    sha256 "14033d9549ebd3086e84cd058ab2df19e90acfc6c1e3c1b4d62f4a6b8c8058d6" => :mojave
    sha256 "961b2a574fdf47d8fd0e74e9755bfb3009147807a316869fa2444d61f9b4123f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
    ENV.cxx11
    args = std_cmake_args + %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
