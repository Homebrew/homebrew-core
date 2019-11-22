class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.800.2.tar.xz"
  sha256 "09962d8d22b98aea32633f6b6ad9b15189888b905f1f092183eda3c5bff35457"

  bottle do
    cellar :any
    sha256 "f13df5fafa38becbc3addebe806abbd0c823d1c65ba9ee72c9f71d91907c1f7d" => :catalina
    sha256 "be230681eb2958e133312bedda58d4bf2da6cedfa0c3f07d4c7a1ea360bba29f" => :mojave
    sha256 "c51085922f4e24fb1d1eb4bde75d329602c585820b4d4c231c8e50f12ef7d3d9" => :high_sierra
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
