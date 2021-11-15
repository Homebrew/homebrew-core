class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.2.tar.gz"
  sha256 "db1665dd2163697437ef155668fdde6101109e064a2d1a04148e45b3747d5f98"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_big_sur: "214c8032cd621e44527cacc9af0800312e95922f7d79e58a94c93a09977638de"
    sha256                               big_sur:       "aab42d95974b15167f1a240f853283eed81a928877822a0aa8ee67664f1992e6"
    sha256                               catalina:      "6b0190b615a9929cd74f03e97ff62efdca225ce9c7afc171ed3f5be31f2a8afd"
    sha256                               mojave:        "b7d94176b089fc5959b6accb2da9390f94ab1863902f0f189bd542566815578c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d74e2b42ab0c62c1f2cf35d515cb9b3b87c24b9e3f480553064748d686fa3a04"
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
