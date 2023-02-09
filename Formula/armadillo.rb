class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.4.4.tar.xz"
  sha256 "2439c9859b35b7d3d95a21a86830d3365f9d6bb624317690e383402e26040398"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "804270a91f73fd11df5f2162b0afa421a73f528ba65ae0f8ea5c3b2bb071de73"
    sha256 cellar: :any,                 arm64_monterey: "17b254380bd6ac1642579bb82a65adcbe208713274e91420659970b58f793df8"
    sha256 cellar: :any,                 arm64_big_sur:  "254cbed52a347b42dea42ad222445095aaf9e64ad712116f9ba31e91ea7c0f5c"
    sha256 cellar: :any,                 ventura:        "30d2538ac034f552da94961192d4ad3536b23b734e69a002edc2f7ba33a4fe67"
    sha256 cellar: :any,                 monterey:       "113938a6771b3f583baf4c5ee75011a3f7a20aa2544611fbc11901d9c38a5964"
    sha256 cellar: :any,                 big_sur:        "1b1e5a2665f7d1cc6ca62a082993f2c10e14735d3887e3eff63ac64f43292d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f202c54471b6b844287cd1fc5fbb6e3264901926cdde13fed22796f7a46123"
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
