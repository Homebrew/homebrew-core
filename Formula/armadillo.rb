class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.300.4.tar.xz"
  sha256 "97af66cba7afa21d742d234ecdf06957c9a2e9ac6b55dd4cfd362ebcb48f5bba"

  bottle do
    cellar :any
    sha256 "4d45dca5fda2fc931c7c5d5c4ecfe5d8fc7c8ffaaaa9d8a867b563d5aa9824a0" => :high_sierra
    sha256 "d389d525bafe85289928da191bb378169d1fe63773916534b7f45862036a0ae9" => :sierra
    sha256 "aebd0529fd6f785d573d332e2cb9587576f80ce06eef51dc05e75e241c306c74" => :el_capitan
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
