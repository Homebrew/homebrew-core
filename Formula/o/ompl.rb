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
    sha256 cellar: :any,                 arm64_sonoma:   "3f8f8f022294172b2d74b13644d94bce058e0cf881b44a86c8df765cf8023467"
    sha256 cellar: :any,                 arm64_ventura:  "47e21d41ad6cbe0f673fd07ad899e99d7515c70e4e7c4812cfcc4ca776f9b1b3"
    sha256 cellar: :any,                 arm64_monterey: "e60d38140988aff917129b5d77bfaf9282ba7bc173ad13d6427f2a282373fafb"
    sha256 cellar: :any,                 sonoma:         "21b5fa47779e98cc2d17a5ba9ce12c4441593fd9dce8b6c224b55f24f0d97e92"
    sha256 cellar: :any,                 ventura:        "54f56154ea3dab3eface3119867c56cb6689d4920dead827b25170b8d1e071f2"
    sha256 cellar: :any,                 monterey:       "2d5bf2748e5d9ce80dc9e9573abef784df41609cb4bde0236462196b58cf31bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f775e98e4cdf61e19db76872ae97c4e089dbaadbed77898c550cfe2205dd704d"
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
