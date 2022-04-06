class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.0.0.tar.xz"
  sha256 "7fdd4f041a624cd9bf23c9d84982d9188ec70352fa8ea03461a9d4da1165f0d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eafef8b7c45dacc6b126f48af362c9a32bf3b9560f8fb8410d5f28e6ce72295f"
    sha256 cellar: :any,                 arm64_big_sur:  "0ee9dbfc54badc737cde27c1d00d31c4d57be628fd246179005074f748f4945b"
    sha256 cellar: :any,                 monterey:       "2a0df90707a8ac52db4be477b0b1f90acd0d5eb27934eed455fe4dc654b4525c"
    sha256 cellar: :any,                 big_sur:        "b329f8a8b55ad30593cc16129bd662532776e10caa2afba5c208c081b84fbeb5"
    sha256 cellar: :any,                 catalina:       "4cd6d492ecaa040d805f9a03c6914251e340052960dafe7413f3347485e740fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86e01536ec46ff7fef85541848209855dc398d252448ef09cbe3f001d36176cf"
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

    # Avoid cellar path references that are invalidated by version/revision bumps
    hdf5 = Formula["hdf5"]
    inreplace include/"armadillo_bits/config.hpp", hdf5.prefix.realpath, hdf5.opt_prefix
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
