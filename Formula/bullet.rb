class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.08.tar.gz"
  sha256 "05826c104b842bcdd1339b86894cb44c84ac2525ac296689d34b38a14bbba0dd"
  license "Zlib"
  revision 2
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "c24a6a53450090dbccc161dd17f2555b8988934771019809c4c5e33aca9864b5" => :big_sur
    sha256 "565e712684c82a288a59d47bc9bbde23ff076fb6b48f85433b1997516b014b72" => :arm64_big_sur
    sha256 "c6fdc1cb6d9d45e68ed4c2ed841edacfc0d7d1b44ffc05c77869329260f2c266" => :catalina
    sha256 "8c66500f251d89ee7ae7e9c282984fe81f43c21dd9566024e47132ec78a1322a" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_PYBULLET=ON
      -DBUILD_PYBULLET_NUMPY=ON
      -DBT_USE_EGL=ON
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
