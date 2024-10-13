class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-14.0.3.tar.xz"
  sha256 "ebd6215eeb01ee412fed078c8a9f7f87d4e1f6187ebcdc1bc09f46095a4f4003"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd8f2a9238f2ed1342f90bcaccfa16be257195b00afcfe00ad163c5db96af4f2"
    sha256 cellar: :any,                 arm64_sonoma:  "5494509545562e10b3f4b73968e4c6558957111fabcec58311976d97c8e8534a"
    sha256 cellar: :any,                 arm64_ventura: "b18f008d3e59c702a17b9850d7e129413646815b2f23cab69663ac86d87b07dc"
    sha256 cellar: :any,                 sonoma:        "a5d309d87feb8a4516be371207087695d4049f640fd06e8255f759d6ac24af99"
    sha256 cellar: :any,                 ventura:       "5fd2bbac3110aa5f68f6bc12a5b70f5762bfd58b70fd4db1844c42957b67fff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc65a1a732d92d576baa12ac1267cc08df1a93f78eb6cb23683c68d6c450f59"
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
