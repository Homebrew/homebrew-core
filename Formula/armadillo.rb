class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.5.0.tar.xz"
  sha256 "ea990c34dc6d70d7c95b4354d9f3b0819bde257dbb67796348e91e196082cb87"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ded2592ecdc4378c3fe498796e47a2ab4fee493553c8c0a1066ca9bc5510afc8"
    sha256 cellar: :any, big_sur:       "2bf252fdbcd1823695dc1d914b2499a3780fc8ca4ba1a6f0486c025342afea0f"
    sha256 cellar: :any, catalina:      "c9ae28faad412cd094f2439f7b84155c5fb79eee00f5e69068ac1219237c8827"
    sha256 cellar: :any, mojave:        "427e130459c5358e598cc301cd3776648be05a10f632ac3a5c9cd0b4738d898c"
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
