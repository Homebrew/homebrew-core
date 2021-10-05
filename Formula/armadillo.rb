class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.7.0.tar.xz"
  sha256 "9bf60db6fd237721908747a0e56797b97b7ceae3603f2cca0b012a3b88265d3f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9b94584728821bc49c1ed73d6468c2a966ab2f2ce5f1d7d34cf25a6c1497d07d"
    sha256 cellar: :any,                 big_sur:       "46d6850f70b6728461abe14f120bb6e427005160825476a96d6fc7bb8bb74566"
    sha256 cellar: :any,                 catalina:      "c2462dba71bc1b598998de5ecc395df67c425d1e727872c222a409fe219ee48e"
    sha256 cellar: :any,                 mojave:        "14102a05910f254e7fe96374251354b72f71ecf51048c2c521f43526eefd2dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7908653ace63c5ce803802b3c14d50bd20d9d853bafa3d4e44762ac30192c54f"
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
