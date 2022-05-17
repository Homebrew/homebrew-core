class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.1.1.tar.xz"
  sha256 "bfa6154a5fefd832d28d530a58221fe4a2cff2a3bbdbd82e109bde53fb29dcdb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9cf8238eb713d90d4ffd48bf8ceab7fd6f9e1166d59a24b43c294dbc88ea7163"
    sha256 cellar: :any,                 arm64_big_sur:  "521c2ed9ebfa08b406387d2aed88515c1c8b59559c0993363a4bf355898981d5"
    sha256 cellar: :any,                 monterey:       "15d1a52a27e204590a8df6c2ec8630ec4bc5d17098a084327faea1492b7d3c25"
    sha256 cellar: :any,                 big_sur:        "69105277782eaf31204ea257bd483424d8f1a77f2acfec67e9885351961bc576"
    sha256 cellar: :any,                 catalina:       "b94b5223a873f8baf78cf9b7acc003e36d515b70dd7e60567c28288bc6062dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5217c57a3c87a46c1de0cbd6e1816f1595258b830de854a5ae463dda92e8722"
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
