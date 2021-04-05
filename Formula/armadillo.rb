class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.4.0.tar.xz"
  sha256 "a2540f1f8ee1991ba1b14941daa3986fb774484fc678978d4d00bba87360102e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "78034b18c4654e180fe3d3609305e26efc7bd684306351ea4e1ea61b4386b2ef"
    sha256 cellar: :any, big_sur:       "93f76538a0632dba6091c664fc723cc80121fadc1ccddcf5f077c0da75a38e8e"
    sha256 cellar: :any, catalina:      "4d9295752c75be89f63ad7d5d278023746f3572f83f254fff34328657cfb1af5"
    sha256 cellar: :any, mojave:        "501e705b90cb17ac82b2732a128fcd9bd94544b8d4783dc010922e693500e063"
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
