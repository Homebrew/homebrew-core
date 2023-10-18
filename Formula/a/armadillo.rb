class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.5.tar.xz"
  sha256 "f6f1c987f9bc2b52e9718835cc416a525cf58a6d575a851d219c0c6ab5b8c563"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd9db00c517ef04b7e584ac28804affad20e139b3cb77f162ce3d607aa10187b"
    sha256 cellar: :any,                 arm64_ventura:  "2cb3a53933fd8ee4e0a85b412d17ff8cfbbf4d68b125668db66383c7ff80ce10"
    sha256 cellar: :any,                 arm64_monterey: "058607ee7854e8398db48fed542b7c1228ceb759bf0489f6a47a7b8377992293"
    sha256 cellar: :any,                 sonoma:         "bf879998feac84a8d694a683b8498b4e2f5a31ea9591be167fdae2840bec2eee"
    sha256 cellar: :any,                 ventura:        "c244def036861f1302a7c45d0d89b558a822b76fe343d487ebb40c91c4275f9a"
    sha256 cellar: :any,                 monterey:       "5c340e7636ceef758055bd18f8c9ce5756450db774fc2aad6b50170e72e6ee57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd926019c83f6624dbde5f90e388d8794d306c2a0c5572a1d7c190c518cbc8b"
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
