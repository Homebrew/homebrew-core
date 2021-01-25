class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.08.tar.gz"
  sha256 "05826c104b842bcdd1339b86894cb44c84ac2525ac296689d34b38a14bbba0dd"
  license "Zlib"
  revision 2
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "cbf1daed6725c676797fb40910049ffcff8e2c28f52614f9da5392585c4b07ef" => :big_sur
    sha256 "a5a64a05831e6387debb1f54dbfa9609478444e131562f5a5f7be09fbd434b33" => :arm64_big_sur
    sha256 "8beddcd17b7277b00526201a97d1057fe9881ce62a9a60faf4b73dcc054393fd" => :catalina
    sha256 "c11bec4ded6cac76461e6f8ae18342770a812c3bc5d5e574924b0840a35a9e14" => :mojave
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
