class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.200.0.tar.xz"
  sha256 "998d4c689fe5c18e393a5d129aa5d1fd649592ae1a94e0c280d3f88e01526aa8"

  bottle do
    cellar :any
    sha256 "fa941c1e60d1475ffe0ec6f798754f31ea9379468c55783bae36e8116842280d" => :high_sierra
    sha256 "bedcbdcaf6f4dc0db2f6f1557ac3c15ec535770490c9c57c1181eeb6fef38aba" => :sierra
    sha256 "c77abff90027174b827adeef4ee06e8d652ec4d062b4d8534890206603a21275" => :el_capitan
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
