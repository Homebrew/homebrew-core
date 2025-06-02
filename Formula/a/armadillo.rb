class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.4.3.tar.xz"
  sha256 "c3aadd59bdb0ea4339b056f29972f92ee19fdc52f68eb78d32d2e4caf4d80c3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2dd31251940a13aa0dca8554371d419eb58fdca38d640a43aab3d9c75056292e"
    sha256 cellar: :any,                 arm64_sonoma:  "b33e5a584c6a505f0555bc26a9019c4421a0ebc7302d6153ce2b35b4abff3662"
    sha256 cellar: :any,                 arm64_ventura: "208053115fbdff16629eb7fb4d583cee056d1426aaf03b382bc8344c88d36bcf"
    sha256 cellar: :any,                 sonoma:        "d273a0f19ee3a0e5c6c9a38df26184c8182644a3634634d0e84bd8c960845871"
    sha256 cellar: :any,                 ventura:       "4dc3ecd398634c3f679fc445982941d08e0460fac5e8d06bf4acea985763a301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fcd74a4441a1b6de511d4ccde22684c4d51aa1f7e17a8a5f4ef0faee41c6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0545b7938bee28727261ee01fcc76a4e74fde81a5382c035851fa235a0bd484a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
