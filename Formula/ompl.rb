class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
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
    sha256 cellar: :any,                 arm64_ventura:  "e5c2263d2ac730ebac237401f874c517dd8e57676bef891f14d78ef18deee745"
    sha256 cellar: :any,                 arm64_monterey: "3119289b0d4f77b083acf7be1da96699587faeb51fd24f294a3dec5115f251f8"
    sha256 cellar: :any,                 arm64_big_sur:  "9eee5a89b79556ee8733da78dc3109e6736e5084722c6a74a5e853d657a233a2"
    sha256 cellar: :any,                 ventura:        "10ef9362526815aa4d4d314a7dda20743242de837b55bb5f29a606ec08d128eb"
    sha256 cellar: :any,                 monterey:       "200c5a35215981bb781134170bea604e6b7ed1ba3463e80e5592da22086349d1"
    sha256 cellar: :any,                 big_sur:        "edfb0198598aa74f209299e215fb7ec5651b1d78891177b02aab4d8d87a64f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44610fe44593c2753c1945d564c1baef523573f33d9fa0ba6cf30d247b5c5ba2"
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
