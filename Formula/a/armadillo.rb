class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.8.2.tar.xz"
  sha256 "03b62f8c09e4f5d74643b478520741b8e27b55e7e4525978fcae2f5d791ac3bf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c102903e8249a1ca52ad2bbd52736ac57707e1deb22e5fd638e35830a7945e1"
    sha256 cellar: :any,                 arm64_ventura:  "1191a6823f71e81a475b5ee638f38a4d2e5aebae1d3862a6c9866a22e1150385"
    sha256 cellar: :any,                 arm64_monterey: "06b3315a73787d26c3f11c7f2c85f42d5c8a420913d4e8216081900db559bf3d"
    sha256 cellar: :any,                 sonoma:         "bb186bda9d97527c3e30284f945633584ce6402bf51fbddba8b491790f9801e3"
    sha256 cellar: :any,                 ventura:        "8a22b884fb65df06309075cb0528d69992e61975a2d07e5669b18ba3267870d6"
    sha256 cellar: :any,                 monterey:       "ca07970bca4314491027e268f2ebb496703523ef3719aa1ee031a4e2a506912d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec0c91f4a7f48d116a1c19fab9010b2f8c0842b28905f5c20a703efa1a13a50"
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
