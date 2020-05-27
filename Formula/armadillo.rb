class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.880.1.tar.xz"
  sha256 "900f3e8d35d8b722217bed979fa618faf6f3e4f56964c887a1fce44c3d4c4b9f"

  bottle do
    cellar :any
    sha256 "6c33e1e0d617f1a55dde2bb4d9c232d58acd2eb197b43619d2cbd5a26289ff4d" => :catalina
    sha256 "eaaee6c1268dbf34e432377ba40d69b8e733648165faad5347c308738afb5de8" => :mojave
    sha256 "ef920a9b703746510c5289e4c8a5c1591c5b46de2ab86e785ba01cc2c51f9639" => :high_sierra
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
