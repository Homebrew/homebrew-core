class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.2.tar.xz"
  sha256 "e7efaaf29abda3448447bdf8cba2cceaa19afb802981b62f0c6384c842b01609"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8805c045292744559ea755f4175da372f814ac5845eb6bf8ff8dbdad95453d6"
    sha256 cellar: :any,                 arm64_monterey: "cfb18700f3628f665e83f7e3cf26a8fbd2de5af2d1ddd9abbb44ed68c3a2f69c"
    sha256 cellar: :any,                 arm64_big_sur:  "a76bce3c5b182ff2f0c73780647f885bf83a43ed429dcad1f966e56ed96462e2"
    sha256 cellar: :any,                 ventura:        "29b82177a011b048df79743bd66c4ec3eca52a923a4ad183064f105a93cfa902"
    sha256 cellar: :any,                 monterey:       "148eebbbc2f3cba1753cf63162a155990c2b2f1a920dca3f0d70980fc6650b6f"
    sha256 cellar: :any,                 big_sur:        "ab095d60ce45366d565149b4db7896b8dc55bc250f9dffb76f912cdf448b8850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41761408a1e1dceebd9ea1b9700b7cdd1a52105770466a299ab30e7d37b1eded"
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
