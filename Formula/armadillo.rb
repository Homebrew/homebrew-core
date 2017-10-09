class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.200.0.tar.xz"
  sha256 "998d4c689fe5c18e393a5d129aa5d1fd649592ae1a94e0c280d3f88e01526aa8"

  bottle do
    cellar :any
    sha256 "01f22f1d006dbfa11e8146cfb76bbadbfe488eb75aa780b389254deba82ecb0b" => :high_sierra
    sha256 "eb21553c3c15c339bda5ec70f4a4f45937d0006ed21bd1e623276ae361e989b4" => :sierra
    sha256 "f3944429d43a38075902f1ae60bcc6e0230d01728b4358827c0dfafed4952f43" => :el_capitan
    sha256 "e4a2788fcdda91eba736f990cc62c739f92ffca2d913110bf34dde5119eb3b15" => :yosemite
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
