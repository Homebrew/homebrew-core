class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.860.2.tar.xz"
  sha256 "d856ea58c18998997bcae6689784d2d3eeb5daf1379d569fddc277fe046a996b"

  bottle do
    cellar :any
    sha256 "7075d82050c109b819d36efcf286f4893a7c95f4b1715f217197235e95143009" => :catalina
    sha256 "10cd18ebf57249ba9b5cd4a99cba55e55ed756f64b1f0aef67f7905f92f5c48c" => :mojave
    sha256 "8584f5ceb94b03d3289adb35a7eda1c57f9d90b06a4ff9f38e77688d33e35b69" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

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
