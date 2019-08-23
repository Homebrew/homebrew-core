class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.600.6.tar.xz"
  sha256 "eff4aa3c28ab10ba0dead39cc1cb05364fdf35f0971125dfbe3b8c92b60f9372"

  bottle do
    cellar :any
    sha256 "1b847809110aa67d199a42725ecdec037453590d634f4c5a20c9bca31917eb71" => :mojave
    sha256 "44008b7a70de5e6cb0d0a00d8cad0dded0ced1940d84a756a2417ff96b07eae7" => :high_sierra
    sha256 "f43f5b168199ea94c300c17961365183ab9152eb7f40cb285d22167680811c34" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

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
