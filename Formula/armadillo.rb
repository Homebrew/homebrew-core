class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.2.1.tar.xz"
  sha256 "7d8e74d248769af23fc894d8bb88f05e32317933cbe4da8f3c56be8f89a9fcc4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "94587f624e8b62067da57f669954f83be16c8ff6fe55ebaa6bfd2166a5c8afce"
    sha256 cellar: :any, big_sur:       "4aff3ecafada07cdf45aa66fd5fc64fe343ebf53179e77637ddadec3fcfd6364"
    sha256 cellar: :any, catalina:      "ee9cd300038ba9321ac2ef06b19282020fcf468ba5c3cca5dda5a91c42674d98"
    sha256 cellar: :any, mojave:        "ce43a28d6b7c05f6ffd14d58e88dd917ac8c3cb834475f88f09bb6763df7b9c6"
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
