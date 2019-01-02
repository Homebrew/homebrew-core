class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/2.88.tar.gz"
  sha256 "21c135775527754fc2929db1db5144e92ad0218ae72840a9f162acb467a7bbf9"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    rebuild 1
    sha256 "5284036f39c7469ba84bbee409fc2b82de37073649c3d872c192731b216a9df0" => :mojave
    sha256 "e7cdf082554cd6e320f756c051a418816799d52a920c9192068ac6637bb6f5d5" => :high_sierra
    sha256 "bfea29b63b6eadaf0181fa3a1baee1e9513a2b43b9603fcf996201164ebec049" => :sierra
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
