class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-12.6.7.tar.xz"
  sha256 "df32064bdf5c47153cf180b3c2012c8a194a07ee892654a6914b486fff2cfa69"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a27315c102ca51e0704ad3e604458ab27d64531b1f0be77b947dc741599d6a8"
    sha256 cellar: :any,                 arm64_ventura:  "86f32ca237b9c434e9105418536f4156a4f0785eb1811a2a9635a0fed78b0690"
    sha256 cellar: :any,                 arm64_monterey: "9969a0fe3eb260f9f56cc7f2ea048329f3aab5c5c2d3e2fe483d5042d379a250"
    sha256 cellar: :any,                 sonoma:         "ec32a400e58c40039c72f88f380230d3fa021f993f29227abb0173714decbf8e"
    sha256 cellar: :any,                 ventura:        "3727eaad4e2d858305a05a8fa087effb7524cf42640169fe013a1b7637e06201"
    sha256 cellar: :any,                 monterey:       "2a3b830943778de1353b316dbb79e6969c6b01f02f3e2bea8c62de161ed49c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ca34d96855f01fac7e6736a944de44fb761111dd7aee22c370fa289cecdcc3"
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
