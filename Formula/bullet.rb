class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/2.89.tar.gz"
  sha256 "621b36e91c0371933f3c2156db22c083383164881d2a6b84636759dc4cbb0bb8"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "2871bb63205a9fb0f9911422729628339be0fa84b903063a8ca39abda15e6f4b" => :catalina
    sha256 "41b2dfaa33c18ec6875999a4112e9214b1e956cb8b4e86052fd80aa7127a3612" => :mojave
    sha256 "c9b07e0e13f21cdd31cd71c32b4a5c7cca5bd181867a8a1c5bc95b5e261f3bdd" => :high_sierra
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
