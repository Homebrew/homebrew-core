class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.8.0.tar.xz"
  sha256 "7c5d2fd4bba095733829f7fe03d4a74e732b81c75dd4d40001163487c967d5bc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "380e79881679130ecfbe79ebf7ba5eb9110f0aebc2a16b0d606a68aabc71a189"
    sha256 cellar: :any,                 arm64_big_sur:  "6bb26d5e19e614637d5a479b0dbd4dbb601f525e783ea7bde68f212633051c3d"
    sha256 cellar: :any,                 monterey:       "9ef79d9ab5ab06e1faefe842df0527068f9505bae65ecc1356a192877111a809"
    sha256 cellar: :any,                 big_sur:        "8886c575a5aa23d72131c0f71b54d70b02a1d1908f69d909de36d60621b706b4"
    sha256 cellar: :any,                 catalina:       "c950b57da18b1f91a71ec1c068daa4486de1d4110ca3afffb7897c6a19a12ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00ed583ae541cb47b8499823cef72044a42fa77035a70872de84bd166ac291c0"
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
