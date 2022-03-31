class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.8.2.tar.xz"
  sha256 "89fdd898bf6bff75f6efc3a301817e4ede752b9a80927fb07ee358b13e353922"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e9e53db6a08b645bcd80b65d5a68ac84fbed9d6ef55fa067d20ae20d09a43d2"
    sha256 cellar: :any,                 arm64_big_sur:  "a6369ff80702a1da78da07fadbc089a2af0d24d320656010fda38f0035cc62a8"
    sha256 cellar: :any,                 monterey:       "8149e479fec337de6b8ed59ab8e6ed2b992cb559d5aa57a46344c1727aee349f"
    sha256 cellar: :any,                 big_sur:        "b8d15bf921bfba3889070bd98a583733260ced9ec2afd99149a099ebcc8fef39"
    sha256 cellar: :any,                 catalina:       "1e269ba24ac375cfcd4be989eaf66904db98037df009c57f446cf3c6c31158f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "139d520f8da492b7fbf43c285aa2d039b4531fc857fcb2827f4ee3ff6b552067"
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
