class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.700.3.tar.xz"
  sha256 "6779ab4e82b8487dcf08e58d6d7d86f20b1c0032c6817712a95ec6097fe4528d"

  bottle do
    cellar :any
    sha256 "99dea9d73f23c53839696e39900232e96e0178f7ee961c1c0117baeb8a798354" => :mojave
    sha256 "3e38f2499b0dfc10fdca780a4805ae63af9b9d06bd5e8713413146deae110ef5" => :high_sierra
    sha256 "913109882a7570001b0f37114d34dc158fe6c6b8fa86262e5eb951af3fa39841" => :sierra
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
