class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.2.4.tar.xz"
  sha256 "dc4c91954ab11490bf64d2dfcc54a802f14393c756a8d545ac155eeeffa7fd93"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "59ba61a87b9267a47d9865c4eb9f309f0c0f1b2df68ca77975dece3f0603dbf2"
    sha256 cellar: :any,                 arm64_big_sur:  "af52d30f11259cf45ceed09ec65901b15ed7144eea7732fb36ebdd6c7b17cd86"
    sha256 cellar: :any,                 monterey:       "020ad83e3d272ff0f8fbba25eb5c2f12422abda3d782d746b3846fc0fa40c13b"
    sha256 cellar: :any,                 big_sur:        "4e55e1faa3628d7c56ddd4b48e6de82098d67ef12e76b30f19773750b4ccfabb"
    sha256 cellar: :any,                 catalina:       "5966fa440709829b819e908caa77bbcfc269746789f78a6e019733483725519a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b2e1d99e13f173c30d527ea38b7ccfc15e5f9811ee882eba05ce428c6e8edc"
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
