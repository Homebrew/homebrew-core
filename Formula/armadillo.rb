class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.200.7.tar.xz"
  sha256 "e2787d40bcd46edf70f65ba4efd523ccb8b96a93fdb8f76da6adf1e921cb7df8"
  revision 1

  bottle do
    cellar :any
    sha256 "6652fbd21f3c18f0f8082ee7d417b6e7d2f5adf4e9a8ec662dfc048b019a5437" => :mojave
    sha256 "1511561213039eb89f3d3f837f36c742fccb59dbb06c3640343ed03b199c890a" => :high_sierra
    sha256 "8bded7bcfae6922656b810ca6085827268d92805dcd7eac9712dfe6d7c722ff7" => :sierra
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
