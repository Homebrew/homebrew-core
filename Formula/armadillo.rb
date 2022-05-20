class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.1.1.tar.xz"
  sha256 "bfa6154a5fefd832d28d530a58221fe4a2cff2a3bbdbd82e109bde53fb29dcdb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a2f2da0ff4ecc1606e94978cd0e064b499ed4852d83360da27bfd98587716b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "12b58ea1505826789e7db0dc78dd5e9aed800600be6718a071245b42b96204d4"
    sha256 cellar: :any,                 monterey:       "4ae16c7b90e222b29dc1a8b978c91372a5a85b26a99cfd780eafdf8bb006f06c"
    sha256 cellar: :any,                 big_sur:        "80c33e1c965a1acd8ad1c85e43e251c9da702e83f7bae2432a4808f7ff00391f"
    sha256 cellar: :any,                 catalina:       "420024783a439e299daf8a8f74ee1ff83f682c3f463e5e640def0615cf92554d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d33d2480c7dbe625b8533bec563819bc667553535a0061c28723ac6ed43af3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "openblas"
  depends_on "superlu"

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
