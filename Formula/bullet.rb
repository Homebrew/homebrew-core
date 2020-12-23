class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.08.tar.gz"
  sha256 "05826c104b842bcdd1339b86894cb44c84ac2525ac296689d34b38a14bbba0dd"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "14b8f6e4b3cf471efc14f9413d9e398392560ef4dceac3f39d28d9c898f28c88" => :big_sur
    sha256 "cefb377b3ad73d2fdbd9866ea60fbbc2938ee7c2d501700f491171da30d7bbe5" => :catalina
    sha256 "25881ffb61074c13305553ff0766fbcb3bfe3500e3e48ee027c1da96fb048c9d" => :mojave
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
