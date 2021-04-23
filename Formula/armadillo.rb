class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.4.1.tar.xz"
  sha256 "e5a451e055de5f8b0484acd5cab2ec5dbad6de28737b5cc72510d892ec69a580"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cd3f10bb16c754afb16be59addef38f2bd554b7c5d67d9cd8beeadfcb0e3a070"
    sha256 cellar: :any, big_sur:       "e6a7a13a5c88ec14fbb848899a95e8d53449c0610d2ceb8103cfe255f07ba372"
    sha256 cellar: :any, catalina:      "825556ffe3056f0724acd3d8d2f2bfed7385b3affc6ecfa7a7e5e5dffbb37170"
    sha256 cellar: :any, mojave:        "b9fe74953fa17dd70cc789b7ba133caaaf815be323c974c57a541b4d8d585351"
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
