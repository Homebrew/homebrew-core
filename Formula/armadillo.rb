class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.800.4.tar.xz"
  sha256 "bc0e54b729f5edcad1ff886159e203d947e105d832645252d8ac4045a1c68fed"

  bottle do
    cellar :any
    sha256 "0539547bf9b604dd12a81355d5e4055cecded546061251850f9b9346223a0177" => :catalina
    sha256 "c331707aa9b2f1722d6d848d306ce5af8b395caf25a826fed4d9c7424a4e2457" => :mojave
    sha256 "e33d6990db5c748989664bff023f3a48842a82d0fe49f0946c23e43b123b51c4" => :high_sierra
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
