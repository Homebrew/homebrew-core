class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.2.tar.gz"
  sha256 "db1665dd2163697437ef155668fdde6101109e064a2d1a04148e45b3747d5f98"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30ee71e15b93d121ab4115219e73a518d64650a8bf557f8ec0074f13d746ac47"
    sha256 cellar: :any,                 arm64_big_sur:  "d917e5fdf5c7d440fd91b82b258f675d47dfdd98f6dbf1666297063c97847da3"
    sha256 cellar: :any,                 monterey:       "6df2084f25065baf411c8d8308e2e8794ec64710dc12892d86ecd03d7e2221dd"
    sha256 cellar: :any,                 big_sur:        "21964e04b91b8246c5910fdedd6f038417f04b9d86c2c2fb79f6a06e00871f07"
    sha256 cellar: :any,                 catalina:       "c9691b20bccb579326f24add8b6b4c377d4f7bdf2e656a7de44b8811f486c0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fec9ac266afa86e2cf676cb6acd864146b6aa1932870bf7761299cab2727c88"
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
