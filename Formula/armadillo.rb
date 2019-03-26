class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.300.2.tar.xz"
  sha256 "362541af7eb7f343bff893a3ac11fbb2c5cfc5966f0b6ed67f7f2779f5d256b4"

  bottle do
    cellar :any
    sha256 "a4a69fffe5fbd7e47a32bf973aaa3efae016c037687a09c0a9314fa28672916b" => :mojave
    sha256 "d44944a44459513ff06eb00704f9dbd628be905d8db95ece1cda0892a76f6c4e" => :high_sierra
    sha256 "1189f58712529fb24150bf513805f108a2d2699fb739d653caef289798fb1c88" => :sierra
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
