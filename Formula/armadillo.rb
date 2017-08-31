class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.100.0.tar.xz"
  sha256 "a3adfbe099586af764d339aea97251e46155cfa074a06efa21c4de9dfa1c71ea"

  bottle do
    cellar :any
    sha256 "f6de78c5eb7ea29da3db0691d672fcd3bb5cee2beee477679e1607c111560cc1" => :sierra
    sha256 "498e9f96cf16235df9786138ea99c8ffd02ec5cd1aafcd3065e2f4e0f9e0288a" => :el_capitan
    sha256 "199441bb0338ee2e2b7af6f56bdf53a5904b17c48364ccc4a6d08e3f11ae9d00" => :yosemite
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
