class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.4.0.tar.xz"
  sha256 "a2540f1f8ee1991ba1b14941daa3986fb774484fc678978d4d00bba87360102e"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e04c7de9c1d6915d23eaabd099b39fac2ea368ac9e833ec31acd80c8624ee73"
    sha256 cellar: :any, big_sur:       "fbda88ac109efeb559f7a3acc1e16a65d4019b0e08e2c9fc8d417db6e9c817ac"
    sha256 cellar: :any, catalina:      "d53d3c66e77f994a50e09944a148067a5fd4320738a2abd0eb9a1eeb171a1a72"
    sha256 cellar: :any, mojave:        "144e418050c3a6adda4f9f71231c420c50c8e85f53af273e6a518f9c039d4cf8"
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
