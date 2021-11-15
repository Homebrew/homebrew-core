class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.7.3.tar.xz"
  sha256 "aac930d5fbc23dca9453ff3647d03f7d90d9584a4556719ad7bc7adab7db6ff5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3af9e528e49bbd75a01c85cbe2d0def4eaa77546e41859db0388e0849b2b05f0"
    sha256 cellar: :any,                 big_sur:       "1e1e524abe92906f994a7d8f9a427ee90b1fed4217c5a53689ff37df36cc283c"
    sha256 cellar: :any,                 catalina:      "9c04456d46a12b02dc035e400c3265155d0000bb9c4159d54f271687e3f4d68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b64170819d686bd9506511df5283ae14e77c9b336a4a5ebc2ae354df6a44d50"
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
