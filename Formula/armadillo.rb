class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.600.0.tar.xz"
  sha256 "5f00c735e97fc23c910a225d1b6db9541af76022cc74f9b8b327dfa347926b40"

  bottle do
    cellar :any
    sha256 "3d9ad9d4eb210c1e8079d35b5bf16a22db6ff9129ddb78d94684bdfea473da90" => :high_sierra
    sha256 "2f94665e5aa383cc53c3d0b6fe25d1b509a8b51a541e0b0780d500a1a89b03bb" => :sierra
    sha256 "bf7ef1afcd06e0925ca8d2ce5a5a5bb427e67dafbac2d7573a8659697a6f03d4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "superlu"

  def install
    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
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
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal `./test`.to_i, version.to_s.to_i
  end
end
