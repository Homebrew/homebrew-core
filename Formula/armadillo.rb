class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.800.3.tar.xz"
  sha256 "a481e1dc880b7cb352f8a28b67fe005dc1117d4341277f12999a2355d40d7599"

  bottle do
    cellar :any
    sha256 "d5f22edc7e95bc8b2571d36448d3b324b006c38a18d6c4fae6c7b663bc359bf2" => :catalina
    sha256 "9a2e05eb13649d63d8b562f9ced506c721185270339334530fcfc54e33c873de" => :mojave
    sha256 "5d0977074c32f4b96f0f3806f9539b5318c17d0807d08664c636bdc7c9115e38" => :high_sierra
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
