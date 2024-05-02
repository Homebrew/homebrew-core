class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
  license "BSD-3-Clause"
  revision 7
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "29b5ee6e97b08a26596798cd2c86d751dd4626d4950fbd940be9a38251b8c34e"
    sha256 cellar: :any,                 arm64_ventura:  "2c6fea0193038adf2ee3f51512c6d9bf2305b1c8f2d5bc7eef29554bb286944f"
    sha256 cellar: :any,                 arm64_monterey: "0efce905456e1425ee4c777d7dd6f0d53a8e99ee709b11f647e16c3951746114"
    sha256 cellar: :any,                 sonoma:         "c3d56c5fba2f1cf3d52664749a294466a0bcc54db6a0652fccc7c62950246da3"
    sha256 cellar: :any,                 ventura:        "de7c4d8e8860b5f716c4ed2a6c01df3439fc6a67215747f564469ccd33c0b45d"
    sha256 cellar: :any,                 monterey:       "8d989f9b5cfd43260253271344db60973eff0d6123eceb91b5ac5af4470dec51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e821df680b3757fe7aeaaf4f17d3d78b1fc04487c8e3338ca59d6b44b049fd39"
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
