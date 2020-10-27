class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.0.tar.gz"
  sha256 "a7df8611b7823ef44c731f02897571adfc23551e85c6618d926e7720004267a5"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git"

  bottle do
    sha256 "f58fc1ff49aeac3a38aa2629385019ad854e9624b4c6e3a3f9051456494984f9" => :catalina
    sha256 "9d66bb50880af5db4f3fc3a1d85140170643518fc72e78ccc6b7b7814261d198" => :mojave
    sha256 "b11650509f65bcf45ea04acdd7fe4bebaff22f829c512d73c308e75476f0a94a" => :high_sierra
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

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-1.5", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
