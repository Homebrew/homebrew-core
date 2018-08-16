class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.100.4.tar.xz"
  sha256 "0864a17e4abc014e7202574394a5222941831fed0d65a361edc655225d56fbdf"

  bottle do
    cellar :any
    sha256 "c0b277c8915d681aefe8ca8d8a96a754b1c4b880d3cf143b03dc191b93446876" => :high_sierra
    sha256 "d732a0f9dbd61a4acbc5abae21b413433eb5025e7214b240aa07be8ccbb97061" => :sierra
    sha256 "f34e2e13691fd62031e06ee64b27c02e5ad668dd074a8e7780bdf9a302637670" => :el_capitan
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
