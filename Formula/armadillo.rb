class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.4.2.tar.xz"
  sha256 "e6860134f1ac9656c6a1ccc74c74b75f8c5966ac8612841f2fbf0c91ce39f4e9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79de8063069ace12ce22812c8b0b26f2b15c8cb99a07da7c5a7dbd50eb6fd3a5"
    sha256 cellar: :any,                 arm64_monterey: "33c1474ebbb15fa5b0043c133ef4250f1c34dd718b5482a65365296805095cd7"
    sha256 cellar: :any,                 arm64_big_sur:  "d5aaa745d3dcd454d3b1d0e581ae658e10a4b0d1c3d2411e05df5a7b76db740b"
    sha256 cellar: :any,                 ventura:        "8a6910bbacca5c736f865b8a9b59ee588661bef6f8bbcd1725c2144bcce14ddb"
    sha256 cellar: :any,                 monterey:       "dea49aba4c79189635ed727f1dfaa4f2901d7f3a08f88ae87a44995550655496"
    sha256 cellar: :any,                 big_sur:        "a41d94e0025c2650a32c9223e95f70ce1ff05ea0bff7d1b336ae27b36de5b499"
    sha256 cellar: :any,                 catalina:       "bed0f51daefcf2656c41792393b0556c4dab4ad6b724fea11c37b222826a6e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69dd4939331c9c848b6893cb8e804ac1b66647ed58169198d55110b6ee3468de"
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
