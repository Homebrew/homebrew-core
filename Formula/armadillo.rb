class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.2.0.tar.xz"
  sha256 "df5ca215901c68c63467c0bfee14f08e34d875a47ab0f095082ab32ddff4f243"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "853e2a21c64c3b03898d7171456a65fc20a6ca975b57dac422ff2ff6c68f2920"
    sha256 cellar: :any,                 arm64_big_sur:  "16e567d456a214defe8edd801a399a6c0c136e57ee315d1b59c21db78b252983"
    sha256 cellar: :any,                 monterey:       "11c535bff4072a078bdc328775c7bcd48823b1e114ed783edd4d44411d537e4b"
    sha256 cellar: :any,                 big_sur:        "c1e6cddf940a00420adc82e76db260b07b9dec9359e6cdf7591695c7201c72f6"
    sha256 cellar: :any,                 catalina:       "5c70a26d7d22f7195434b2e4b86a743e8a98a12ca63956ca186da6c8e632060f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b911e00d0b63f19671f998c84d3083b94a0dbbb4c7410539b22d6a3dea602f3"
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
