class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/2.0.2.tar.gz"
  sha256 "d867190a46a7f730923475a68af2e09fc9e796017a59be395a4bf3900d0c3ae4"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(/href=.*?ompl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "55d5ef7ad11a283d7ada5fa15f76794a7ed542eafbe4f563c0d68973dde566a8"
    sha256 cellar: :any, arm64_sequoia: "ce11e695bb6f5e344cab1f280fe50613ba6539ca3fb6f9f499d1bf1ec6d7a0a7"
    sha256 cellar: :any, arm64_sonoma:  "96de4cd0a0d1e9b81f1506a53ab3bacb0dc39f61b3edc75267b352a32b179ae3"
    sha256 cellar: :any, sonoma:        "f7a86396228b982f81ee3ac54c7f88297487f2115c5095a6474a0b109b722562"
    sha256 cellar: :any, arm64_linux:   "5460ad1f16d99311ff5c18ef9eaf0fe7ab70fe96f6f259f47bb41223ef041402"
    sha256 cellar: :any, x86_64_linux:  "9b0573e7972ce788cab912cf97c807876545846f70bab2a29fc53d36b522d889"
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
