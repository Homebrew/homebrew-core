class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.8.4.tar.xz"
  sha256 "558fe526b990a1663678eff3af6ec93f79ee128c81a4c8aef27ad328fae61138"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1208883798ef1532b393e1d3fa402cc0f83ed22255fdb9b6ad9187b2c0854db7"
    sha256 cellar: :any,                 arm64_ventura:  "c799be5003482a6291811848cbc5254e83e42a3f9619b8afa6eab195ce8f96b6"
    sha256 cellar: :any,                 arm64_monterey: "be55f74195518a00b145e4786dc17945407def019f127e19dbc1143b536c43f7"
    sha256 cellar: :any,                 sonoma:         "6724725b764a4763c048c7409611957458e97152cc25c217132939f70002daa2"
    sha256 cellar: :any,                 ventura:        "806168422026a15b600b01236f56f5459a6092c74f3b0f88a532e2686e278603"
    sha256 cellar: :any,                 monterey:       "f5d8af958b30958b4513d405ff54e943f1dfb428ef22af6343af1a65d0e12986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8903efcc54074d8bc7108dd6b39b1fc3af1cbd0172c6a8e444fbc92b6ce179"
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
