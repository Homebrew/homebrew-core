class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.0.2.tar.xz"
  sha256 "248e2535fc092add6cb7dea94fc86ae1c463bda39e46fd82d2a7165c1c197dff"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68e7fbb97adc00257478df23659656c061b120ab5ccbe4504e907d45c37c70cd"
    sha256 cellar: :any,                 arm64_ventura:  "766499cb0d1f43fc05aabd34fedcc8cb737a466f9179e13a0f9e9d70999a316f"
    sha256 cellar: :any,                 arm64_monterey: "8eeed39c2609dd2a86b23d5545626f6c67a78367c0ee51bfe1b4667bdc4eca7b"
    sha256 cellar: :any,                 sonoma:         "8db6b5a47d80023c329f65867ef70cc8e55e32691fc5208a78fb0a601acce420"
    sha256 cellar: :any,                 ventura:        "7c932d6837bc650692df680062e771215e452249d80eeb1b8fb4a1eec1d2638e"
    sha256 cellar: :any,                 monterey:       "62ed45c56afd0f695a9d4f9d5938ce275f56da180adabf6984acaf249a24e3bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b20eca052b8531f1fac29c85a85caa3abd4d8c4c26fe41750d75dd65c1905c5"
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
