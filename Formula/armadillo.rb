class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.300.3.tar.xz"
  sha256 "493653bccbfcb65234ed569b765771c3d947d614091ef857927d41ac542a97b5"

  bottle do
    cellar :any
    sha256 "e875a0558b5f392f9aa4fcc23c8a68595370c0c8e5f7da243f0ca33c82be2734" => :high_sierra
    sha256 "5bc5fa97d997b4f3a72532f10db38bb823af1b486f7b70526351a85ae6774965" => :sierra
    sha256 "17e1c5ed305c64ce8c7db6896313ad0179d039b620ef60669df5a3a5afc8762a" => :el_capitan
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
