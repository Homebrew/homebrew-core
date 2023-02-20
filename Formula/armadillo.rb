class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.0.0.tar.xz"
  sha256 "5e6adf2a00996405e80160ab57555d19c268d93cd0637560d59549c1b3e88922"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d5bfde666521b1af91612d4780817cd276b02e2bdcda0094e5dec9e27dda7db5"
    sha256 cellar: :any,                 arm64_monterey: "f4b53f256e78c3ae5c3977baec13728e4204dd6069419646891efc42d73e3027"
    sha256 cellar: :any,                 arm64_big_sur:  "f83e7e5b9c2cd65b3df959eff8892d3a612499d2582c3e20ed272343baaf4e9f"
    sha256 cellar: :any,                 ventura:        "be8f412ef620dd3e4440c3f5449c546182f23f6105e405a4c061391eae02bef5"
    sha256 cellar: :any,                 monterey:       "bbe8c70c81409344aefa0a3b917a8f61fc6e54ca881ffef433bf8b797f274cba"
    sha256 cellar: :any,                 big_sur:        "f72d899e937f18f49c2b3abe97e0182f97a4561b1f327c4c3a4eb13a4f6a9de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a0a3d1afcea59b74c770f889d55bf844d3e2e370a847dcef20570cd4a567703"
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
