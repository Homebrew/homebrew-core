class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.100.5.tar.xz"
  sha256 "7e7dc6f1e876b8243c27a003b037559663371b42885436b1087757e652db41cd"

  bottle do
    cellar :any
    sha256 "015e9ddd9ea1f0bf4754f21d9216a1f214fea58f6f0cf985a0ac9b42151283dd" => :mojave
    sha256 "a72919f80609faabd3fba7db964a14b6bf58319007ef0ee498b43a3f82d18145" => :high_sierra
    sha256 "107308f775c8aa57527fb811886be1a77a8b5e8c134a8b00bdc7aa94fe31dde1" => :sierra
    sha256 "76163b9785b7147d36daf058ac81911635b648afe80abf50a7cfaa334ea545dc" => :el_capitan
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
