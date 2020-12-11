class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.1.2.tar.xz"
  sha256 "96ef79b65c9cecbfcafac6113da85e695c97e796ffffd04b4280c7a8daf5635d"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "02975e5c376769d1d3a1cd7c6b04e49e19c78e331aec08d7a262061540a467a6" => :big_sur
    sha256 "9b87b8586a1ca8f0b24e448004956588f918bb407bfc3b8ed7dd3f5263408400" => :catalina
    sha256 "9ffb259fb092520458e93f2065f6fbaae2e66414a0708ae45147c40b0bddf1f0" => :mojave
    sha256 "314cefb9fa4143d92ae255e2903ca3fb5d21b4d8cf7228f4460174e8ce341938" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "openblas"
  depends_on "superlu"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
