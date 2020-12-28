class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.08.tar.gz"
  sha256 "05826c104b842bcdd1339b86894cb44c84ac2525ac296689d34b38a14bbba0dd"
  license "Zlib"
  revision 1
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "400f206997a5e1992075bf02574372e7b11393b45472092854fa226f059e367a" => :big_sur
    sha256 "2d84bf5c5c4066ace5c0a020afd59dea6fbebb5a2bed1b96ec7d660d35a4315b" => :arm64_big_sur
    sha256 "a2ce4674ecc39e802606a82b28897a28c9e03651e4633a38f43d5c09f7b90a6c" => :catalina
    sha256 "80769ee5343d4df206d4e01e29a68c3e3d8e4b72ab1e644e1cdf8509da14a7cf" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_PYBULLET=ON
      -DBUILD_PYBULLET_NUMPY=ON
      -DUSE_DOUBLE_PRECISION=ON
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
