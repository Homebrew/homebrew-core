class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.07.tar.gz"
  sha256 "068ecf8acbf256d3976eebee75d7d6f5af16c049f10f6b2d8ba28bb638bef3b0"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "4cc47995de996b2153f88551e70ebd0a151c2fab850ecb1d7068d00d2e076c65" => :big_sur
    sha256 "ca6fd3aa213d3ae1e890c15db94b073fdab954062b6ae1fad62c14480d14b4c2" => :arm64_big_sur
    sha256 "38cdb6c948cb2c75ad2d6640629f1cf72b7901b54483f9bc25ba0fd307b90b55" => :catalina
    sha256 "e4a628878c9358b5a986ffddc682795f13a0a3d04f11f8bbf753e98827d4fdbf" => :mojave
    sha256 "ddfb705ac9e42845d9d357131add82eea36bdceee95118a970cf4830a4be1878" => :high_sierra
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
