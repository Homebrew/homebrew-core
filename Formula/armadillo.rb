class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.400.1.tar.xz"
  sha256 "4eeec39c6e4e6feb2e26cc78dba465bccf4807f679b74929453f2c333e95e1bd"

  bottle do
    cellar :any
    sha256 "4122531c5cb8682bb5a578e3848b12a81914ea9495851d9b37bfa62ca7bfd4e4" => :high_sierra
    sha256 "b5260ab776d214be7da81a720033a02ac3576837b27bc5d8e1925347d33b617a" => :sierra
    sha256 "b49646f45ef2c0fa1356356541f7608dfb9e748dab2fd88506beb03d000165e4" => :el_capitan
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
