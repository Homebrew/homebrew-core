class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.300.3.tar.xz"
  sha256 "493653bccbfcb65234ed569b765771c3d947d614091ef857927d41ac542a97b5"

  bottle do
    cellar :any
    sha256 "cf5e7953a2ec691c9747b511c1c658b24f9f3c90aa8cfc63ca0c5d81cd7f6368" => :high_sierra
    sha256 "fdde39a1ef6eb6389faf365ac690e51e158d50f009ff11576b3ff605be91492d" => :sierra
    sha256 "7d5147718a0c37178bd06534b61ff2074057c6c8e401908e5a26c3aa412a8aa9" => :el_capitan
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
