class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/1.6.0.tar.gz"
  sha256 "f03daa95d2bbf1c21e91a38786242c245f4740f16aa9e9adbf7c7e0236e3c625"
  license "BSD-3-Clause"
  revision 9
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ac8f978f87e2733b89b277cd2635146ebd688f9010f4378172752edd46bb56f"
    sha256 cellar: :any,                 arm64_sonoma:  "552362506b178328e541716299039aa939188ed34b88313ae70f8791fbf5abdf"
    sha256 cellar: :any,                 arm64_ventura: "0227accc2594bfb6fb47b413c2c8d16dea914b6aad1142ba0daa2d4d1b635198"
    sha256 cellar: :any,                 sonoma:        "2858c1d0e1acefdf78f51477487d05c7f8764bd139b1a377fc21f6127d76b379"
    sha256 cellar: :any,                 ventura:       "c41347171a28c989d5aee1b9ebac6cadce7d8ec42a8e76df25369cd33bd32c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8f87556b7fe33bfbe322043ee7db8a6cc1de2076bc43cdeda6f357c9d312ad"
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
