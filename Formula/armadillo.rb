class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.8.2.tar.xz"
  sha256 "89fdd898bf6bff75f6efc3a301817e4ede752b9a80927fb07ee358b13e353922"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f7a1993146c590623ec64bf96927eb366c874aa751ef252d77fb4ca1a048bde2"
    sha256 cellar: :any,                 arm64_big_sur:  "f8e9bb1a3eef68a50dd8c099b7a0c5e18fbfb305649214a86614c10141db284b"
    sha256 cellar: :any,                 monterey:       "50238ed4efbd5f9a8a225f85f49d3ee25254c9b950557f1e336c358bc30134e1"
    sha256 cellar: :any,                 big_sur:        "4069ef56152ccb3ceb3eea991676326118310b0f02a1db3dadcd0df810c9b85e"
    sha256 cellar: :any,                 catalina:       "ac3e92541ca58c3e26dc30742cc5c8445eac9d54f41320f8b4e017ba1b507075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391e4b11489404a85bbc750926be6d9a91b2004c73a8f88dfd0f369b4dea3563"
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
