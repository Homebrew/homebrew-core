class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.900.1.tar.xz"
  sha256 "53d7ad6124d06fdede8d839c091c649c794dae204666f1be0d30d7931737d635"

  bottle do
    cellar :any
    sha256 "5e8fdc3a6dc72295bdbbb3833c6e40dfaff4687ffac588cc6dce0debe13edad6" => :catalina
    sha256 "3bc08126695bd875b2d65f93464bb6af94d57be20fd8afd30116802876945dc5" => :mojave
    sha256 "194df3c1ce3c4092f1b36e3be477261800f4ce34728f02ba94094725f69c3d4c" => :high_sierra
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
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
