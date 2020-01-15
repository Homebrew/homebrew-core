class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  revision 1
  head "https://github.com/bulletphysics/bullet3.git"

  stable do
    url "https://github.com/bulletphysics/bullet3/archive/2.88.tar.gz"
    sha256 "21c135775527754fc2929db1db5144e92ad0218ae72840a9f162acb467a7bbf9"

    # Fix Xcode 11 compile errors
    patch do
      url "https://github.com/bulletphysics/bullet3/commit/7638b7c5a659dceb4e580ae87d4d60b00847ef94.patch?full_index=1"
      sha256 "2b08ff21dce85562bd6ff24ae6b71ed55de84b24a0a74d1e8323b7a0f783f528"
    end
  end

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
