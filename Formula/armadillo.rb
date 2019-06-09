class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.400.3.tar.xz"
  sha256 "f4c9ce4ee719e935f0046dcafb3fe40ffd8e1b80cc16a4d2c03332ea37d857a6"

  bottle do
    cellar :any
    sha256 "9d2a5d9bfd06546a88d6011abc7c4c230423ec2f10821fc3e85627d4d29e0e07" => :mojave
    sha256 "a5de0a2f59cabc4e48f99124b9d1bac2f4609c6a31ae5b4f0ea4290be9abcb4a" => :high_sierra
    sha256 "b5b3071ac01f070c076dfca9104ff2f23331cd72678f958c5e7351d1d37493f8" => :sierra
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
    assert_equal Utils.popen_read("./test").to_i, version.to_s.to_i
  end
end
