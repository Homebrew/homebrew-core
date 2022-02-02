class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.8.2.tar.xz"
  sha256 "89fdd898bf6bff75f6efc3a301817e4ede752b9a80927fb07ee358b13e353922"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "064b8e150f7f3fc7ffacc261a5f4dd4191e5bb64d74adfbad487322fa55bddfc"
    sha256 cellar: :any,                 arm64_big_sur:  "912ecd52d3d5a79e726fcc4ac1ab7f00f97c7a3163e4eb52512906c9c2bd4bc9"
    sha256 cellar: :any,                 monterey:       "262560ef76182f9a76997556a85340940578e415f7884377e95aad832207dffd"
    sha256 cellar: :any,                 big_sur:        "75687897c85e0c9d4c5b3df11c7c894f103d82b40e5513286e400e0b5430d97e"
    sha256 cellar: :any,                 catalina:       "cf474b4f224cde406e69ad82c0984557665c1324d7cd4562c34dab6458de49e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0d58fe9c134fd00d0dc79695b7c31562d9209624748be0c10028bf4d3c7ab7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "openblas"
  depends_on "superlu"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "make", "install"

    # Avoid cellar path references that are invalidated by version/revision bumps
    hdf5 = Formula["hdf5"]
    inreplace include/"armadillo_bits/config.hpp", hdf5.prefix.realpath, hdf5.opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
