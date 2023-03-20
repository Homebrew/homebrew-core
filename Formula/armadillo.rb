class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.0.1.tar.xz"
  sha256 "230a5c75daad52dc47e1adce8f5a50f9aa4e4354e0f1bb18ea84efa2e70e20df"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93682cc60b3eef024e25854bb452a2a4b95bc24b4cae57004db3bc307fcd1c0d"
    sha256 cellar: :any,                 arm64_monterey: "af6218fe47524795cf5736b3c6d984aafc22f627c1daa3f403deba15d27e6341"
    sha256 cellar: :any,                 arm64_big_sur:  "c0de5057f4849e8b9a5b9d8d117411c8f34f702b083b91b1fd9a9792ed438484"
    sha256 cellar: :any,                 ventura:        "fcd6f3168bf786cd27757d6326019c43ac4a9a345bfcc974916b382b6f022fd3"
    sha256 cellar: :any,                 monterey:       "917526a71998faa22286822393e92c7c83f78a618e64f8d211bf29cbd104441b"
    sha256 cellar: :any,                 big_sur:        "09604ca2c396bc00e36d6b15e9b029c2e41f342d35f43f894f4fa612199e435e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce3c3225dc7ead426bd2cd254cfb20bb81eec90b88620790be0b84d439003b1"
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
