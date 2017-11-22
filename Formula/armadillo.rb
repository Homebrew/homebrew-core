class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.300.0.tar.xz"
  sha256 "854550007672958d15f3951ae13aac6934b3016234f392d26f168a55b363dc3c"

  bottle do
    cellar :any
    sha256 "ae4e42d1fcc12a54c7c753a1691bd4f96e9961568a76572a2a752419dfb4757a" => :high_sierra
    sha256 "f0e0def41928df77bda09889e099fc9418a4aa395462721b7cebc849001891c4" => :sierra
    sha256 "edc7f340bdf98137b136a70b4e2b286df9928fcac5a306c4a72f86955474fe1c" => :el_capitan
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
