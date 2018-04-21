class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.400.1.tar.xz"
  sha256 "4eeec39c6e4e6feb2e26cc78dba465bccf4807f679b74929453f2c333e95e1bd"

  bottle do
    cellar :any
    sha256 "1a245a0636afa09fe42d3c6dee8d23e464c1d676db2dcd66ba84927042bb2c41" => :high_sierra
    sha256 "9a5675da1137bc47e5f474c12b1db3bb6fdffe219bbd60564f1de65736eb74a7" => :sierra
    sha256 "ea25a40719d83d405af97593ddbf7073aa4ccd9a191c1ef0357444273a3430f5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "superlu"

  def install
    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal `./test`.to_i, version.to_s.to_i
  end
end
