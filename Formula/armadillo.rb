class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.5.2.tar.xz"
  sha256 "63f23cedc548a5e9404816e50cf8f8fcc492ab1aadc6c0cef30bfc2afcead95f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8b195a26c203a812955e447753c0c4cd04b056481242b6e46569ba9c67ff16ad"
    sha256 cellar: :any, big_sur:       "265aaa0c4bc2f4fc2e89907919b00ab2b70cf6ab5a168375e3ebcae7e7a2f05f"
    sha256 cellar: :any, catalina:      "d9aa0d4c933650c6941907b496a85ba4230c183f586e5ccf4c9a8c39152f2ce9"
    sha256 cellar: :any, mojave:        "ae86a7c885233a73ba9d9b395b5426d7792a55678a9f795e8d496286bb20b436"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "openblas"
  depends_on "superlu"
  depends_on "szip"

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
