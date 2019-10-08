class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.700.3.tar.xz"
  sha256 "6779ab4e82b8487dcf08e58d6d7d86f20b1c0032c6817712a95ec6097fe4528d"

  bottle do
    cellar :any
    sha256 "20231c4b71e4a82b7eb52469ee97fab5a57b3fd3f148bb9df32c3ede8c3f7657" => :catalina
    sha256 "c821fa48f55f6753c1d909746222e563396c99fa7a79ddedf30145a11a50d441" => :mojave
    sha256 "700c396795b3c8fe20139bb2cde2a01f6bc1729d286f2b9edd53f6fb2fd29bd2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

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
