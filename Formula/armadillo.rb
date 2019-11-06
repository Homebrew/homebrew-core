class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.800.1.tar.xz"
  sha256 "ebcf57e031465848d2110d2d9f0b09a3bfd31d7e117327e6142935f2e783daee"

  bottle do
    cellar :any
    sha256 "53dc9c33c0a55c973b0b37387283c6e71e1d70a96abcb4ba9d45c66e5a104e6c" => :catalina
    sha256 "f651056e53d7889711562b6662f00cc61f97b0abb548e654acbedbe5870aacff" => :mojave
    sha256 "3632a4b74ec698b8a8d455e9392e728183b68c484adc4c08eb81a55a5cc87014" => :high_sierra
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
