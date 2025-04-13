class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/1.7.0.tar.gz"
  sha256 "e2e2700dfb0b4c2d86e216736754dd1b316bd6a46cc8818e1ffcbce4a388aca9"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e9a9522103a30c56a0718090e4d41a073c6523503c4dcdecf28970ff30a0dde"
    sha256 cellar: :any,                 arm64_sonoma:  "da9eaa07331ed710455af2606156237f04ae9b27155f147b11fae6bd0c91fe2b"
    sha256 cellar: :any,                 arm64_ventura: "0f0adff99744e7097bc6762c033409a1a5bbde0de4bcef56ab22c40fb8f21d49"
    sha256 cellar: :any,                 sonoma:        "1030af098f5a1f751d38df58509b2a9aee0656a7866222afdf911db45df771d1"
    sha256 cellar: :any,                 ventura:       "60bc51ca3db7cec58e67c7f119ec8703495368ec5d335cbd7f0df49b4f1015a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7906093b02cc99ac44194289765daacb1228a578f48df64b75f3dca0d857c41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8edd2630b5ffcd2c0c6fdf34acde8468e02209aa2043c0342e5ca582f2de3a35"
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
