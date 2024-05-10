class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.8.3.tar.xz"
  sha256 "2922589f6387796504b340da6bb954bef3d87574c298515893289edd2d890151"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91581eeea07c47954e719fdef8c964027ebeccae3c88cd059c0adf7f346e912a"
    sha256 cellar: :any,                 arm64_ventura:  "50711d850b1a49414679bce7d82df1b8d05b5e3683ea76276a2a300384a41984"
    sha256 cellar: :any,                 arm64_monterey: "a15f323c1504af5a32ade9a7882e577904b1bee8da8e53cc196c84fd03d7bc7a"
    sha256 cellar: :any,                 sonoma:         "eef354133b970bbd06c1b3db0c4112a905015989bc51ce76c6f54c338df6a716"
    sha256 cellar: :any,                 ventura:        "51650b6fb52ccec73d895fae548da8f4cf732a90e4a5b1aa6451a8231e73de44"
    sha256 cellar: :any,                 monterey:       "944519057dcfcad30a67941c091ca21fcd82a2cfd43d920ff6090ce56df02c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0748e38af3d48210c705d7e23bbe40abed409654b271596385821234c613071d"
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
