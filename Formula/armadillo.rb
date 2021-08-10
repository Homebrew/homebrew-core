class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.6.2.tar.xz"
  sha256 "2a803d6f8f76d407db9c15edc3894965238c8e589f94cc907a8373ee945728a8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0344bd993165cf6b05e8d697eeb5a6956e73e4a5f2b4b3e2d9f4c80b7480ce1f"
    sha256 cellar: :any,                 big_sur:       "11c8cb78e7a99befa9d57153ba4e51844ccbb9dc471f2b4df55bb915466ada31"
    sha256 cellar: :any,                 catalina:      "672039181b0d20615d10c18860df2e2187c7c00a48f16d9420edbcf5c8cf086d"
    sha256 cellar: :any,                 mojave:        "64110329e7400b96adba49a08be247019d2b861e592338e1768fe48df26e536e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d179b1e2367cc872dad0366463619d805b8b464d09151f77c0411c38cda0f79"
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
