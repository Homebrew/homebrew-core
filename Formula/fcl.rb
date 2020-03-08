class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/v0.6.1.tar.gz"
  sha256 "c8a68de8d35a4a5cd563411e7577c0dc2c626aba1eef288cb1ca88561f8d8019"

  bottle do
    sha256 "20a679e735c69b58c4a97da7c03beac0f45ad80fa9230fcb25cf2f0c4a191f1d" => :catalina
    sha256 "7bd24120f684a275154b6275cb9668e3447c2607cbb51c5ca40e6878171a6626" => :mojave
    sha256 "9e4e2abcf7c2ce96c2208e097d27845041788b1a66e3a209756ea0d78ed45389" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fcl/geometry/shape/box.h>
      #include <cassert>

      int main() {
        assert(fcl::Boxd(1, 1, 1).computeVolume() == 1);
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-I#{Formula["eigen"].include}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
