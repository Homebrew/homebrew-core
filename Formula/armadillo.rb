class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.400.3.tar.xz"
  sha256 "f4c9ce4ee719e935f0046dcafb3fe40ffd8e1b80cc16a4d2c03332ea37d857a6"

  bottle do
    cellar :any
    sha256 "eda356976968a059c6ea7052a652e0e60b6f21bdd9d9cc13738617a83fd3d174" => :mojave
    sha256 "3f0be987bf3fcbe476ef84f1f583fd49f803ac417f62c63764b654abb17a4f57" => :high_sierra
    sha256 "e9a337b306c94443ac6472e5b8c21dc1f29bd65fbe1bc804519ea6b0379d5bd4" => :sierra
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
    assert_equal Utils.popen_read("./test").to_i, version.to_s.to_i
  end
end
