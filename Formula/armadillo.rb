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
    sha256 cellar: :any,                 arm64_monterey: "67cab37e04928a2d1e78c3f54082f65a7eb9f8f5e5694e377835429a777f7d88"
    sha256 cellar: :any,                 arm64_big_sur:  "c66e52a81bd44837b32f06ba2f1516ed06b8c9fc34ad82d208de5fd7a488290d"
    sha256 cellar: :any,                 monterey:       "d6d5d83ee068430b62d4e85da314433f5a4cd0852a0cd4ef3ebb24d4141db3dd"
    sha256 cellar: :any,                 big_sur:        "fe856056f45ff3131560261295cd333d807e66e08b2be1ff385062a7d09b099f"
    sha256 cellar: :any,                 catalina:       "e78ea2a9538abf61df02be2bf081a724fcc5acb19d34e0c95fa3342207952060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a441688080dba06b41c288921108e3c4746b430a729b590a4a5b344ff40334ea"
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
