class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.960.1.tar.xz"
  sha256 "57de6b9eb547f168e5dd2d2736c75b609bb2d1761120f608ff6530d7247082ff"

  bottle do
    cellar :any
    sha256 "ce59f8055dec6ac44e427ee8ae2a62dd4069e7800edf6241238e36c6be770386" => :sierra
    sha256 "6a1344f69abef546eedb9e5d4c8417514cd4f5ed8233747fe63bd12361b1bfcb" => :el_capitan
    sha256 "6b78c0bcb68bde9943018f2864277f9ef6c40381c2a4ed2fa690871e8277991e" => :yosemite
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
