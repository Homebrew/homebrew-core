class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.2.3.tar.xz"
  sha256 "4c2e97ce60707fc1f348f44f7af0cb6d2466d0aad0d0ea4bf5d5dc180e6cba41"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1012232ed0005e893bc8de17e7fcf8a8f2222d9a43af912220278ea471311b64"
    sha256 cellar: :any,                 arm64_big_sur:  "ca71d0b9b12033372e528ca439040390a601a3ca5a16fc4308ce19fef3bb0e44"
    sha256 cellar: :any,                 monterey:       "cef4226de4e99cabb4fe5f2a43fd5da3a744c2e0f11b968a2814407b5525b6c9"
    sha256 cellar: :any,                 big_sur:        "4b4b94542b64f10389dcba5e1beeb468421980bb175f2855d220e383fba65e15"
    sha256 cellar: :any,                 catalina:       "b873f03d6389dea0bb6eece563596dfff4f8c70e3c0ca216b574fd1cc61de3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ec24aab4e081597853815eb88bc79d4e88a1d633c06ab8c069736bdb93a5ca"
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
