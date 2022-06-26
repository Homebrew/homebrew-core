class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.2.1.tar.xz"
  sha256 "2ed1139340e6c0896f490f0dbec73875b0222e0ed9f4971cf8c41342248b9ec2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0580e38bc682ab5bf9d98fe0bdd40cfd7d8433b35806372378a791d989f5acfb"
    sha256 cellar: :any,                 arm64_big_sur:  "a4d1434141cffaf801c1027aeca41387a5fa6ee849ace9328ed18d90636b255d"
    sha256 cellar: :any,                 monterey:       "3abead7b35d9bf10b6e6e9dac3199d35e4f6c0cae5f88a6886ee94dfa6ff09ba"
    sha256 cellar: :any,                 big_sur:        "821ba3c687955ccb0b01dc2c6430eb73d871dc97125b0102e1f62e2692de4608"
    sha256 cellar: :any,                 catalina:       "fe76e509da370eda578bc4a8a9054ff761f147d5b31b3c2ddad84434722ee615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41844b7059a9a5f4be625367ca13db694b1843dc926936f8326f8705a417bb74"
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

    # Avoid cellar path references that are invalidated by version/revision bumps
    hdf5 = Formula["hdf5"]
    inreplace include/"armadillo_bits/config.hpp", hdf5.prefix.realpath, hdf5.opt_prefix
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
