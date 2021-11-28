class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.7.4.tar.xz"
  sha256 "2c1b32c5b259b05e34bc2dcde1cab589cfcbb58179c72a93c5daaea1e3950652"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8fc1bbd9459489dacef87936575faa4f41c26e4722efc0e447deed5cf82e82f4"
    sha256 cellar: :any,                 arm64_big_sur:  "2c351e54b8df61e3e2ee7d784c8e76d19b4c113d3a59ec18985401b3d8c8880b"
    sha256 cellar: :any,                 monterey:       "79dbac56a1161e3ca6345c192e21e1f7bca1a8b978db69ee18cf869149c5c134"
    sha256 cellar: :any,                 big_sur:        "8b51bd74d4276a5ea72b701e4ce2340a0a2874f72dfb58fc6d92c246a5a519b2"
    sha256 cellar: :any,                 catalina:       "bb4c0fd752569b3004565e53c7700f2ac8dd0efd84656a82bf9d4486345c7604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600e4545bc1538836efd4b9f01a918f5a2193f57369ad484a6a7b916a351849a"
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
