class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.3.tar.xz"
  sha256 "81f9d5f86276746a016c84d52baf421cfc35bbad682a2b9beff6f9bafd0a7675"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8e12794a137946cb54b4e74a0b5adfdea4ff233b4d3c6d9cc03b797f32a8bee"
    sha256 cellar: :any,                 arm64_monterey: "e374340afd0ce10d5b28e0bd3fc2b9991767341a2a8a45d34cf95bae5701cb39"
    sha256 cellar: :any,                 arm64_big_sur:  "fbd0ee643ffd15ce4731ba91ff89bd3f89fcaecb0ac620478222767cd59fcc20"
    sha256 cellar: :any,                 ventura:        "dd70ff6a8d24ba46da4b065dfcf743ce9df3646a96fd5344f199cb682b69b2db"
    sha256 cellar: :any,                 monterey:       "05819e4be156f2ba8076959358cf8d8d43a60ab0eee4a8f5145759e73e69f22d"
    sha256 cellar: :any,                 big_sur:        "a7bc33f208d08f5930ebf76ede6788543386f5255c3e329f997229da6edb5277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "963b8c16e3646c9dbd43491bc397aa4eb6d0b91daac44768ff99dcc0370dcaf5"
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
