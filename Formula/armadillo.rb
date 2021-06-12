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
    sha256 cellar: :any, arm64_big_sur: "65c08793eaa8977ad49a89d4fe8e984ef89336d9b776e8c43013fbba2fd8aa80"
    sha256 cellar: :any, big_sur:       "2248d94978753cf6ce63c5539c09efa05ad647599d2463f26f626b39575e3368"
    sha256 cellar: :any, catalina:      "23f60d6397278c6e761ef56dd0f50696869025f0debc872767a1da3f42aba9b2"
    sha256 cellar: :any, mojave:        "12367696acd74302c0acb3584ef53bab689c2fb8a24923186b21b4c6c8624dd9"
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
