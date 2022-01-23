class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.8.1.tar.xz"
  sha256 "5087ab5a2268e5ce71798c1afcb6d1fb246463f8dc88a60db49a083600f98332"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "567e2bf7a891779434b0c275f736f768be76e86dddff8d3d01991eea64c5cc7a"
    sha256 cellar: :any,                 arm64_big_sur:  "aab592379ed20dff4c7f8be929e67c078bb17ed2850ff62e9cb09c0a14f944ec"
    sha256 cellar: :any,                 monterey:       "28255bfc66285bc7765e4725297e3f7d2fc7b95cbfe735ba466f6463d3eb7d45"
    sha256 cellar: :any,                 big_sur:        "f02e31a43c4c053f6ec7179d5e6ba59bf693272edcc77e37b9d1ee776fbb7a9b"
    sha256 cellar: :any,                 catalina:       "4a0a7b59ffd4f1c91353428a5b7a57a094e4db65669106b0359dc658833cd993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469a023001371f78f452c0a3a9e961f524234c1a20566a9e90f288c0959344fe"
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
