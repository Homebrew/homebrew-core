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
    sha256 cellar: :any,                 arm64_ventura:  "7b79a2dc2ad5b04e57aafe819c77d9f9b8d4121a5bb3907089d2008ad5404db3"
    sha256 cellar: :any,                 arm64_monterey: "00a4461734a9754a8ee7550b5922650b76c148c19c27ff561d28d2f6f3ed1a3c"
    sha256 cellar: :any,                 arm64_big_sur:  "1727c6630e64ad4e8e1a3e78bd0e38c75aa5b8a39e4d71091b36562b404acfa1"
    sha256 cellar: :any,                 ventura:        "6ec74ab92a88596fc5b9b47aefded0974f3cf2252a03f0324582da1ab6580868"
    sha256 cellar: :any,                 monterey:       "20b0fae83a2598001d4ddae25400a45df8e5505b29a520c72b7c92b501ed3296"
    sha256 cellar: :any,                 big_sur:        "525bfd4187fbfaecf4a069715bbe328a13a2aaafd02dfbbd42ae9503b50f3ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de9ad93e3a7f94e795f5ea697693e8dc1a17365e734e5edf735e00fc050fe2b"
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
