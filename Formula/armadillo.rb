class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.300.1.tar.xz"
  sha256 "cd0f8e5e4dfa04855b32534c601646169ff4c0368a4ba071babe6f6ec461dc05"

  bottle do
    cellar :any
    sha256 "cf4a7c9a518b90d1b45cc2fa3226404a767d4dc871360392a9f33cd07f9d714d" => :high_sierra
    sha256 "0b8339f8b1890b73049f3bcedae9bac8564cac6149638242fbc09ee4f1f9b01e" => :sierra
    sha256 "af54e704ff473bb1cdd2998c2c0ed1f4fd3080976df5e33a015d4167a2c89df2" => :el_capitan
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
    (testpath/"test.cpp").write <<-EOS
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
