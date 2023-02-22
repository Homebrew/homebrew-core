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
    sha256 cellar: :any,                 arm64_ventura:  "66450ca0b3919f5bbf3fb7108afaebe633b9a6f00f1a278782e7c3aeb678e98f"
    sha256 cellar: :any,                 arm64_monterey: "04b9fbbd260c886862293e8b17ba00237caddd4228e32004c1d466b5a1948ace"
    sha256 cellar: :any,                 arm64_big_sur:  "7a4e90535d0b335f4b7538db0df81f1bfe3008e8deba03fc6f1ecbc3efdae5ad"
    sha256 cellar: :any,                 ventura:        "c1de3f442639894833837f2f7d5a0c1ec603d79d48b13539a8e4a7b7f84441d5"
    sha256 cellar: :any,                 monterey:       "50df67037e8e05f1b613959d7fd3db67fb2d7a1c74f797915a50d1e921558436"
    sha256 cellar: :any,                 big_sur:        "90dc64cffc65ebf28ba9620ed7ca30093904a4d4e2c8d70226dd4fc7f6f9be12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464ea0d4642b834c0c4e9f8417fb24400e79cbd83e3d7471c6ea4cf374b01123"
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
