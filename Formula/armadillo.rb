class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.2.2.tar.xz"
  sha256 "94295fc62ecc4373e5a96c7b62b923fd71a81f315aa9597b282aafd8559e9435"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f0c1b6aa5583da65cf939b736c374ace47170d64fdba5fc848709b95c3cf708d"
    sha256 cellar: :any, big_sur:       "7e8666013161c64c061b9e21dd2a0e7776a563e7d2fcac7c5e22d33399b25f2c"
    sha256 cellar: :any, catalina:      "e8f231d4cb41621885d9024e6ac0621d1e5553506932bc9bda8a222822a6ca97"
    sha256 cellar: :any, mojave:        "b433dfaa5d5af7a5efa540d009ed1c2ba8609b1ecc85eb44e871739c574b235e"
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
