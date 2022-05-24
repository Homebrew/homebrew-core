class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.2.tar.gz"
  sha256 "db1665dd2163697437ef155668fdde6101109e064a2d1a04148e45b3747d5f98"
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
    sha256 cellar: :any,                 arm64_monterey: "ffe47e64de3abc87d21742b2f91d8e82d15f452dfced450cae396800dfe8d3a7"
    sha256 cellar: :any,                 arm64_big_sur:  "8ec7941715b61540fbefccf77957e10de0283fd5faa247d8b49081597fa35fd2"
    sha256 cellar: :any,                 monterey:       "07b00d741d2b807ba8bd4a73663d75728cce63bee2060ef5c1c99010a2eb1833"
    sha256 cellar: :any,                 big_sur:        "cf1c091ca7a9df020d37cacd7984237c1a495ffe82408e5c48561f3325704e29"
    sha256 cellar: :any,                 catalina:       "dffc06c254246bdbc7dd21e078c22fb84efcb9ebf838edd848ad0624a1fd8b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee3b59b7370f80c621b2cad70bbbf6a487836b75951dcf0a1f056048fe8716b"
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
