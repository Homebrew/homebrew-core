class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.870.2.tar.xz"
  sha256 "541b5fee4c1c412d0a508791611583fcd4e8ff67c0da0536833e694e700cf756"

  bottle do
    cellar :any
    sha256 "cdb05107530fefa76966c361855d80840e2611b9816bd58202341150460cc543" => :catalina
    sha256 "7f973bede422f9b25e1bf4b6387c9376a7154449b1a7a83cb5cbc5111b753075" => :mojave
    sha256 "8301ac47831bb7df4ada7a3b90d68c56d639ab5608ea9980fa158a01cf91a1a3" => :high_sierra
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
