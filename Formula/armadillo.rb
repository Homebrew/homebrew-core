class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.4.0.tar.xz"
  sha256 "9905282781ced3f99769b0e45a705ecb50192ca1622300707b3302ea167dc883"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a1e694cb4b4960ffcc5531a9950d622bce959718ab610e85efb512fc4b15a34"
    sha256 cellar: :any,                 arm64_monterey: "48c4c8ef8af8cae892b75b1939bc00ec43140bba8387d47906e639034d764f71"
    sha256 cellar: :any,                 arm64_big_sur:  "f9bcf0c3bb21b249dd04fab34548c4ee8477117da2a4f0cac3f77b2f25c93fa1"
    sha256 cellar: :any,                 ventura:        "9cccb9fb245a513af1caccb5ad3eb68708b6f12826d1db5922aaa406940efbb5"
    sha256 cellar: :any,                 monterey:       "a6027879dc5714be1532ff1e3eb16fe1453174c8b02bf638b05f53b1d26c3888"
    sha256 cellar: :any,                 big_sur:        "c09d2c7ef51ee2d2f1face7bdf55f4adeb4ce34351d02e1106db2bf1976498ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f7ac56b5627dc47353570469febb79c905f359151551441080205b976efb50f"
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
