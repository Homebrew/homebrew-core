class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.500.1.tar.xz"
  sha256 "ace40efbe2df4b418ec713c71bbd20cedfa92a55015f810639319dec477aa12e"

  bottle do
    cellar :any
    sha256 "a60ac581bd7b00b92dae2bacdacc66595ab7283279cde1ccc43f445089c18326" => :high_sierra
    sha256 "5b1be911240fe2204e995f7290d30bd0c90613cbf258ff1b4ddf4fd4b2e6fa4a" => :sierra
    sha256 "66a0b4029e72ed87b94de3330f61912d74dd239ea7303bca31d192855dc4e93c" => :el_capitan
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
