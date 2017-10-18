class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.200.1.tar.xz"
  sha256 "9d041975db0e92c4be019a70e961bcbb78f7167c7d36ef432d940f9c54949110"

  bottle do
    cellar :any
    sha256 "3ebcd160d35f180c8f77a8c1360f03340be8194b5167d61e50405cbc552de932" => :high_sierra
    sha256 "081aa3fb1757a641db1f261717bb29537e1d085a375ecdfe46088039f5095b3b" => :sierra
    sha256 "3977b7e887ae539fac0572531645a6e60b7025089681956c95bc7c8e4b6c8453" => :el_capitan
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
    (testpath/"test.cpp").write <<-EOS
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
