class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.2.0.tar.xz"
  sha256 "b0dce042297e865add3351dad77f78c2c7638d6632f58357b015e50edcbd2186"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c2c968eca98dcfd366f0a60ef1b7c8cf350d98ff8c3942da37983fd7e91dbfc"
    sha256 cellar: :any,                 arm64_monterey: "02f1dc5a1371832e81b20f84575b70981fb1b58c24754138fefa261a9aa39189"
    sha256 cellar: :any,                 arm64_big_sur:  "386dbe260d96c506824a80eab03a5154e634cecd829fe8f5e60a9d41226bb746"
    sha256 cellar: :any,                 ventura:        "5b632ed5d52df922550cada45f0b5f33329d7e36cc988353ee84cf99c1f3b13e"
    sha256 cellar: :any,                 monterey:       "2bced19187812f8516aff3b44010a3ee9637b892514bc7826f07d491046d36c5"
    sha256 cellar: :any,                 big_sur:        "c38d88da3a6c5f9f1b395b5ac70ca346529abb7dcaa66b66e5bf4e73fd444144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baf386d8d94e146528de0e8f6a100b0387307839ce9ea268703094dc2a2c1449"
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
