class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.900.1.tar.xz"
  sha256 "53d7ad6124d06fdede8d839c091c649c794dae204666f1be0d30d7931737d635"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "7156e7a27e68f66f8094ef8eaefa313fb1ad5e5502049cde144cc7769f947382" => :catalina
    sha256 "2e25365969120174213486b48831df5c4983010f7c54e930fd1ba161290c8e7f" => :mojave
    sha256 "a1d623dad547df9d07e01a48143b7922249a71a9b233d532ee8b7cefb7507d7d" => :high_sierra
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
