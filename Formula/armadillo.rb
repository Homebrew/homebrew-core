class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.600.4.tar.xz"
  sha256 "7dadb6deea48c53417fd82035a8f1f25c04c925e5b3300acd198a359994af0be"

  bottle do
    cellar :any
    sha256 "052d50d7318d8b4462b58f5479b0b084ed3cd58503449a81c5ba440b619d5d18" => :mojave
    sha256 "9cfb21290505346c6c4d46e2b8fdc08c0486c28cf7f21d2d4484c01ef13beaa6" => :high_sierra
    sha256 "b79c766fd85e98ab71b47eba55d1b3e4c6a918bc695afa5d480c623bbaef6c7d" => :sierra
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
