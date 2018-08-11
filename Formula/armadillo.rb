class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.600.1.tar.xz"
  sha256 "b942d10bbd0b6a30f5bbe63cb7e8820f64227adcf3a2ba4bb1bc785526bb957b"

  bottle do
    cellar :any
    sha256 "5ada5b3c37b3250eec2695dd697f8f105f95398a41a3e6ad94c78646f489dfc1" => :high_sierra
    sha256 "44927fc8c22915a09c35875d14856df798510d4913fad6159107d6ef69b002b1" => :sierra
    sha256 "797220e47809435e37febd132824637976a1deff71ef9a1593b01a0b56eab624" => :el_capitan
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
