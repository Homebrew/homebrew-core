class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.8.1.tar.xz"
  sha256 "2781dd3a6cc5f9a49c91a4519dde2b1c24335a5bfe0cc1c9881b6363142452b4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00033fadfd668d39f64eb87acbecd2f9d354e5be3a7aedb2eec0255c96b0c5ba"
    sha256 cellar: :any,                 arm64_ventura:  "a4817730f2ca55e1fca041d8ecfb72419a1e3d3fa9e7fdd09c419f1988cbe511"
    sha256 cellar: :any,                 arm64_monterey: "518ac75b1afc427964ed69a3487325ff126a6820f2b3fd40a08ac6d5508ed9be"
    sha256 cellar: :any,                 sonoma:         "556e7b2eab6e51b145924493e9ee17bbde62087e23480c22fe497e8a1efba4f7"
    sha256 cellar: :any,                 ventura:        "ba90dd0cfe621bf5780891d975780f90cb19638f9c12b9f15b83ac970e03519c"
    sha256 cellar: :any,                 monterey:       "215b135d1b0785b4f0ee019a522c9ee038841c6563a2bd7743c254e3804d6f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9bf37461077b944450b77877a0dff624066e3dfbb163fa7446e99a87338840"
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
