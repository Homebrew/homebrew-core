class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.200.7.tar.xz"
  sha256 "e2787d40bcd46edf70f65ba4efd523ccb8b96a93fdb8f76da6adf1e921cb7df8"

  bottle do
    cellar :any
    sha256 "5cad0c12bdff2e375c3daff9016835361761f9b45bc9af19eb5e3ac4141439ff" => :mojave
    sha256 "e446e6f4fb46f2f975eb7864631c143ca235a0bb89776ac4f8282c99c0956529" => :high_sierra
    sha256 "b1de7d65af96e81049a99352c1e32833d205d42cef0fd3ef28b085ea121f3ad3" => :sierra
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
