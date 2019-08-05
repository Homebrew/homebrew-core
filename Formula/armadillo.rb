class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.600.5.tar.xz"
  sha256 "dd9cd664282f2c3483af194ceedc2fba8559e0d20f8782c640fd6f3ac7cac2bf"

  bottle do
    cellar :any
    sha256 "949aa8bf87d391b864bb050ad9ac299299ecec1c9ba2b2287f75d5a993e11de2" => :mojave
    sha256 "1d51a244eefc6156f6cdd77566ddd34aad5b40ca33a7a052862901f77844597f" => :high_sierra
    sha256 "65eedfb5fa1ab9e71a09adf43f3954993603e2d49e5b697197b4cedfaa43d5ce" => :sierra
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
