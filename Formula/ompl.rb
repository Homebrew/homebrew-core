class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ccd3ddf46f7dca92ef55b7bb4a489ce963a5fa970704d0d5feb41644fcc669e8"
    sha256 cellar: :any,                 arm64_monterey: "48dc10208f60928674899e1f2b1dc3b9c23e6dd8fdb418a195e32b3f09f5c91a"
    sha256 cellar: :any,                 arm64_big_sur:  "f5caee24de18a4433c05b670083ecebeae1be0ed68f8ce1ea352ff72df8b4706"
    sha256 cellar: :any,                 ventura:        "6e592b53634c02ae3bd77d65ca5f0882a8baa94eab9449a63a42ea1fcedd43d4"
    sha256 cellar: :any,                 monterey:       "e60fa2eb8226877f3c53e03b8ce68912b6bfeb8bbfd24988406b86c972c1cabb"
    sha256 cellar: :any,                 big_sur:        "9591de73236c06daed6725fda63c675a8b449f6bdc06c7b2bdf0f5e6d8d8d1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946ff80d88357649aae358dbf969215c303184f241ba0105ffdf3da165d17fc8"
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
