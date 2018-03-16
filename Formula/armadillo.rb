class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.400.0.tar.xz"
  sha256 "5cb6bc2f457a9d6a0758cfb15c418d48289909daccd79d0e428452029285dd9b"

  bottle do
    cellar :any
    sha256 "b13a2137e0c2710da670b0b98bb474a0fd179d2a40d9052a34d04e4ac914f9ce" => :high_sierra
    sha256 "f7203ff4d62b266f55f5e7d7fda1b0a1e8d961b8ac992636304a2c88b90e7239" => :sierra
    sha256 "ea2732442d9a46cb14e73c530155868d353fd9b2c8e01da75bcfcf7b121884b7" => :el_capitan
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
