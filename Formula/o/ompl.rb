class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/1.7.0.tar.gz"
  sha256 "e2e2700dfb0b4c2d86e216736754dd1b316bd6a46cc8818e1ffcbce4a388aca9"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "041e10c377511ea45af40e962fa9ce470616dae2cde49c01333731dfe38f4b56"
    sha256 cellar: :any,                 arm64_sonoma:  "b821378e7302d00b6f8aadc22dd606392bda600b236ce744ab04a90617029477"
    sha256 cellar: :any,                 arm64_ventura: "44393bc2559ef2cb1064943fdd2858cd6086b78a04cc0f98dcf19ec53f01bcb1"
    sha256 cellar: :any,                 sonoma:        "7cba8c475175ae9ad1824cb05b8dacf2605092883cb99a0d8fea2f73c21d939f"
    sha256 cellar: :any,                 ventura:       "7aa7fdf5d6d5e83483ce4a3ae8c923f8c212cef486896bba4b3bbfecd125a5eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36d4e4c8ae8e76a01f710f8af160e47e2e995633b8e53c09e8c67509ed64e79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0800e3f94cdbf5727e2f79e6a90fa1a80ac182519e4557d2245d63346d5cbf4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
    args = %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
