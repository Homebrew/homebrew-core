class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-11.4.1.tar.xz"
  sha256 "dadb5fd35bc4dc251b36f5dd80729c3c588d65e2ecbcd4e4e359ad9cb04523fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b230cc33126941156593e9db225adb5da02188c52a9380f9e9b6c6e504173c4d"
    sha256 cellar: :any,                 arm64_big_sur:  "0d114cd0c6a15d55455379c1c2ccd7a1c0629bbd0420d9207b99a340b8d52b3d"
    sha256 cellar: :any,                 monterey:       "54232832bcfc28382c1b1b176c7cac4c635eed4e946c3ea2ee07a8db433b13f6"
    sha256 cellar: :any,                 big_sur:        "f25868b33867a85c4f078ab9230fdd918e8f1773c3d5f2bd915df9fe8006162f"
    sha256 cellar: :any,                 catalina:       "c95a2b9566105787f63ce623810a9dfbe14f9034913b7ab3aaa4854b0e0edbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0331d5806e55ecccdcd0be250e8c4c308707365613d934664f5caeddb37fc85"
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
