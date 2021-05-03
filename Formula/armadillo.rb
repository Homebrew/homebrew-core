class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.4.1.tar.xz"
  sha256 "e5a451e055de5f8b0484acd5cab2ec5dbad6de28737b5cc72510d892ec69a580"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "26ec067584d6e79f2bfeef09d3b18e9810173234a7abf925e68f766f478038ed"
    sha256 cellar: :any, big_sur:       "6ddf088fdb1ab50c266850a8eb89c0b4c293b777f20bb2379cbeacc16932fb67"
    sha256 cellar: :any, catalina:      "909778699a7074d9c3857d9c2321e3218ad245aabde2fe4ae2ca145740dcb58b"
    sha256 cellar: :any, mojave:        "cfc89ceb3c2910d5b2985594590b7a0ca21f9dbfa2cf4b10d3de204c1f3a4735"
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
