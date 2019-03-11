class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.200.7.tar.xz"
  sha256 "e2787d40bcd46edf70f65ba4efd523ccb8b96a93fdb8f76da6adf1e921cb7df8"
  revision 1

  bottle do
    cellar :any
    sha256 "7b9eb26cfdbf9d19e111c11348d1431ca665a11e87c538e9cf87bd77883c49b3" => :mojave
    sha256 "0642bf308205c2e07765d56dbdc99f0525658b535de6e997262e460fc57b08c4" => :high_sierra
    sha256 "a94cbb9c28bb7e4a93babd4f4737d159988cb20ef5922e2ab2621518bfbe589a" => :sierra
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
