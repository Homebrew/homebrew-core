class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/2.89.tar.gz"
  sha256 "621b36e91c0371933f3c2156db22c083383164881d2a6b84636759dc4cbb0bb8"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "38cdb6c948cb2c75ad2d6640629f1cf72b7901b54483f9bc25ba0fd307b90b55" => :catalina
    sha256 "e4a628878c9358b5a986ffddc682795f13a0a3d04f11f8bbf753e98827d4fdbf" => :mojave
    sha256 "ddfb705ac9e42845d9d357131add82eea36bdceee95118a970cf4830a4be1878" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_BULLET2_DEMOS=OFF
      -DBUILD_PYBULLET=OFF
      -DBUILD_UNIT_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DINSTALL_EXTRA_LIBS=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end
