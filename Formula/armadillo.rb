class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.300.1.tar.xz"
  sha256 "cd0f8e5e4dfa04855b32534c601646169ff4c0368a4ba071babe6f6ec461dc05"

  bottle do
    cellar :any
    sha256 "6e4fe1affd6ee94d3bd3e65f9d62d962d96046e7e8d85c8aa2f01d60d7943a65" => :high_sierra
    sha256 "67972954d78142f451c305d9c129ec838a0171cc4a515dfb72c57d906014bbf9" => :sierra
    sha256 "b9870b553042b4e5a5600099ff722a97fbd8e40632303d931d43c1f72795a5d5" => :el_capitan
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
