class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.8.0.tar.xz"
  sha256 "a89bb6fece5ce9fdd1d01a4bc145cf7cc0b939c5777cca46de69c2f5e3412cf0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "afb2c0c75e736607fd6bca545beac2f258f82bac5aa4cd436ceaff9caec35880"
    sha256 cellar: :any,                 arm64_ventura:  "ce6a0dbeac60ec35a8f0fad10b9a19d539d84cf5985d71c2b3024cd9a192798d"
    sha256 cellar: :any,                 arm64_monterey: "bb7659b9b78855407d8cd6e7022b4b96a09d2bb67d90cb26b587c199c9c5aed4"
    sha256 cellar: :any,                 sonoma:         "84b278788a238c0558a2b8f52907d43af7a5ea88087523ffc46b26d19f8670f2"
    sha256 cellar: :any,                 ventura:        "92007351b7489cb7c444886c38f728589dd2ff4d1285c962b64d846a17aa379e"
    sha256 cellar: :any,                 monterey:       "843679c4e38cb962aff299a94c60c67442dafff17aad609f551d1782c1f92ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d8667768885c232c1eb9e90cd6136ae8de0aafd0f90ac9b257e8f828c5b66e3"
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
