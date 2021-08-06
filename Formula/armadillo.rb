class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.6.2.tar.xz"
  sha256 "2a803d6f8f76d407db9c15edc3894965238c8e589f94cc907a8373ee945728a8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c2baab0e85e172da929809587925cbfcf0705bd56a7fdc3d0cad1b828a542d22"
    sha256 cellar: :any,                 big_sur:       "d42ac2fdfeda7e856a8a6a59dfd1a90e01b8315780fb458b6feb46a22d06c2a6"
    sha256 cellar: :any,                 catalina:      "ac834458244638b460cdd6d55cd41160ceef299db050a8c5e6e5f40a7a153d09"
    sha256 cellar: :any,                 mojave:        "c6b18bf0aed440a4aea1894ecdfd0f8eb462e73677b52d172b28d40b609a5239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9801ffddbeffd5aead4d7c6c96d2f14ef46454674a6f775ec86fe560d97cb9aa"
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
