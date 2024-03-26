class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9f4852f5de265f2a351b6ff01c0d05ddbd6a07f64ad2d19740ff1d527db60ef"
    sha256 cellar: :any,                 arm64_ventura:  "386a395702cb33a1b36199a7c129f96beed786df8b69af4d208db15eb5c23033"
    sha256 cellar: :any,                 arm64_monterey: "0599b6337a982419818b476e7eaf323e2eb128cae82e72cc1f3b296d59d6276a"
    sha256 cellar: :any,                 sonoma:         "f0e9d80171808e0871f7fc3d1a2751f9a2ced8c420588c7f977e816df5e68c99"
    sha256 cellar: :any,                 ventura:        "7599fcdff298949b167a1ff909f0b7fbbdd0031322941b3d17201cb0b1fadaff"
    sha256 cellar: :any,                 monterey:       "5b677f83e756ee5ef7efcbc4cd978c9107f2c9e22b02d347cdc07413098e3e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3bd0c771cb40f051ca251ecca0a4ae8798fc1ef48825e541c21ba33bfb61f9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
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

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
