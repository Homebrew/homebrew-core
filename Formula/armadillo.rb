class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.4.1.tar.xz"
  sha256 "8127635d27dfb996fab495de6ff9ce84bd9b5e04de3c0037fc2ac6de96dcf397"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8bfa994e79918cfc065bccefd9f22975cdff4d4449bb08897f8020ff2be9aab1"
    sha256 cellar: :any,                 arm64_monterey: "6ee26910655e172208752acf7204d6a366fac8814fbb18a2a3d38037c58e4ae1"
    sha256 cellar: :any,                 arm64_big_sur:  "74d1e12f1e4a20dde8318bce2748b1114a83d0a56cadd03eb8b3bfddbf827112"
    sha256 cellar: :any,                 ventura:        "39c8cc6f83c28c605fa7b4f395f1378d4d1a7d791508360646c131b5077d4b85"
    sha256 cellar: :any,                 monterey:       "a1b4f20b46c39e19bec751b34812e7587694c5995d44bd1ea0873343d2658bf2"
    sha256 cellar: :any,                 big_sur:        "e3d18569966947aca2fced13b9c2077c87a64da990fa8f0ba6ce2d971f1a9492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee3de3a11ca4bed37b59a5b95f0ca2a0b17943ca1b9864198c6f8462158fc6d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "openblas"
  depends_on "superlu"

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
