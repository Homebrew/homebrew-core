class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.7.1.tar.xz"
  sha256 "c90e399ac9592cbb57c77544601dd7fce675bb2ea67b4d24fcfbf0be975eeb88"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "170bfedb910f91b3e5bbd0ac9648ace4ddcf358c16487a437a324bd05915a361"
    sha256 cellar: :any,                 big_sur:       "627202e739e77c05287587f3b9f4d40c0050906aa37853bcd95c09888b1e2ed1"
    sha256 cellar: :any,                 catalina:      "581275de1c942acb75fa880d15107daca8575259089b350993952048180f46ae"
    sha256 cellar: :any,                 mojave:        "e2bf41cdb187d7964ba39e2cd62a7e76b060e5ca5a096e3302787a99f5b71a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39f1d749c90a61ec6df92a99e40cb9e6a4d62547c64641483b77b2c6b074108"
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
