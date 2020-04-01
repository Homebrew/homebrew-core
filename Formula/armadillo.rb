class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.860.1.tar.xz"
  sha256 "1603888ab73b7f0588df1a37a464436eb0ff6b1372a9962ee1424b4329f165a9"

  bottle do
    cellar :any
    sha256 "399cf48dfdf7e0a5d580003c438eda5931201b258ea2c8bd248bf2191c30dad6" => :catalina
    sha256 "03d912ade55e81fc1691751543435f0dbee3edb2d12ac7edb32f2fee6fff163f" => :mojave
    sha256 "4b3c8bd9e1d57a331dedb35dcbb401c16b700e97dc94c4c2a459acf108561577" => :high_sierra
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
