class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.09.tar.gz"
  sha256 "f2feef9322329c0571d9066fede2db0ede92b19f7f7fdf54def3b4651f02af03"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 arm64_big_sur: "0865d80fd735e15ea05fc362daac4b4165a0034043d90e5ea0c620ea4b33c990"
    sha256 big_sur:       "bb66686ae45e1f5dcea79ce2aa025631e001e11edc1f7ea4d1c0ab46a359349e"
    sha256 catalina:      "79d5312f7ddf2f95a54b492d2ea46f92f0fffe7908807f4b9eb2e7fdb4738317"
    sha256 mojave:        "f3b6f6ae687d26ce1315936c9f6b1fd82c083538145ff7d2ba6ecd3b9ca37e01"
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
