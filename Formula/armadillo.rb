class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.500.0.tar.xz"
  sha256 "f51c69f45cfbd4773c77ded333c8ff9cdd9a8e0d5a1c011b6a0333ab4b8cbbf1"

  bottle do
    cellar :any
    sha256 "847eb4294f6da444f7b3bc391263d7899ecbdff57a268f963a2f2bc9ec99787f" => :high_sierra
    sha256 "470e41811ef989af0c3373505fb9358f67034be2d958b6e5934f10b3f2fd6993" => :sierra
    sha256 "e51a5b681c4ddd06dca090bbb5a40dba46e366c286687aeffc488f9587196951" => :el_capitan
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
