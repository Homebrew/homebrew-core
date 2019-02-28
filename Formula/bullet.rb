class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/2.88.tar.gz"
  sha256 "21c135775527754fc2929db1db5144e92ad0218ae72840a9f162acb467a7bbf9"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "441f12cab157a05a69e5a7de426296b096fef0b88d0ebf386ce15503e114814d" => :mojave
    sha256 "febfaa699309bb100f9614fce6bdcbdf9f8521be10d2885bf5ad42073c351c4f" => :high_sierra
    sha256 "cfcaf1990cc8f2fd8ebc8ecf93b10a448c51e6991eca5fab599c9c913e1d94e0" => :sierra
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
