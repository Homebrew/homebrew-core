class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.1.tar.gz"
  sha256 "947598190e4f7d4b64b38370307f941e1716b18aba5e73209427d4a747ac6064"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "add9016ffe798af205fe201607e84dac67a9c8ae01fcaad5efefb1a75344eae7" => :big_sur
    sha256 "0c0046ebe8850825b29a4932a41bee23be88589998e49362d82597c67adbe338" => :arm64_big_sur
    sha256 "54e88cc082f922ad904f81021a53c455c9eb389d4ee6e2bfaa9596d09c589f1c" => :catalina
    sha256 "22bd9dcbe10888f3f599f03fe43092ac8dedbb5ba4c167961ea75aef84383763" => :mojave
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
