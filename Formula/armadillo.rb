class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.600.1.tar.xz"
  sha256 "b942d10bbd0b6a30f5bbe63cb7e8820f64227adcf3a2ba4bb1bc785526bb957b"

  bottle do
    cellar :any
    sha256 "a9c86a5850882c5d9138e927038ab54e68d94cf887e9a2ad41a93e50c5db6652" => :high_sierra
    sha256 "eb5bb4af05070436d26b817b579e8ba8c1e3e111ace1a070b8735ffa2a209b8b" => :sierra
    sha256 "09d8ca2f0d91a58e236c1da617bc404778577787ecaab1ca18f58ccc986e6c27" => :el_capitan
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
