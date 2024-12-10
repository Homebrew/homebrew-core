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
    sha256 cellar: :any,                 arm64_sequoia:  "8ddf0b61d4b9f4b0113ccb5ce2f77d2101026a614a88b4e539c6c8e0826bbe5e"
    sha256 cellar: :any,                 arm64_sonoma:   "936f9237df933d9e854ff0abe2d5e42edcc14c3732227dc4fabd8d679175f66f"
    sha256 cellar: :any,                 arm64_ventura:  "0039002b210c5f23e460cb2a99cad82d1e6db9bc5b9544aebf0dfe3325ecda03"
    sha256 cellar: :any,                 arm64_monterey: "c0e8254f283aea3532dd73877e364182d96bf70f949db8f90f4a0aab14727922"
    sha256 cellar: :any,                 sonoma:         "0ee91c9cb10f001e93bdcf38daf438c24aa4314b86020d1bd8c891d2c99ba0df"
    sha256 cellar: :any,                 ventura:        "ddc6f4e98e47c9c752d8384d3b829196deca92f13e1c92e75aa68ec598c64432"
    sha256 cellar: :any,                 monterey:       "1be17fd3d56afd8b7f378b3074b26b3679e370cb06ce700dbe66d8fcc065f992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "474464a4a0bd3c59d6c888ab496c584dd5ccf38da1ebf51edef0a2a161d3278c"
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
    system "cmake", ".", *args, *std_cmake_args
    system "make", "install"
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
