class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.600.5.tar.xz"
  sha256 "dd9cd664282f2c3483af194ceedc2fba8559e0d20f8782c640fd6f3ac7cac2bf"

  bottle do
    cellar :any
    sha256 "b28e62bccc2d6607f7a1143f6e5433e90d9b5ee146b2d2e34b90e183738e8f63" => :mojave
    sha256 "5b5d6c39266b006b87f6a4052cd5a414ddd0c36617205fb2ce006acd74bd4bfd" => :high_sierra
    sha256 "b1b01095d45bfd6dc922d4acd27d0621efa93e192660f8bda69d16cd6ef8c554" => :sierra
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
