class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.09.tar.gz"
  sha256 "f2feef9322329c0571d9066fede2db0ede92b19f7f7fdf54def3b4651f02af03"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "1aaa38aecfc0d31a795175c22a7bf906c30e79226a72b7d10a3cb14a60f496a5"
    sha256 big_sur:       "d48eafeb3a22111a1269f0ba5cd8be8a9a6f9076561595358a04f7c03ffe37f5"
    sha256 catalina:      "58ea37e74322edadcfbf673f463e543db10bb2eabdd71743c8420e95441bd1e9"
    sha256 mojave:        "58a5289bd9672d3a6f0ad7c586f8465f91fd64fb15164841fd48758889982d36"
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

    cxx_lib = "-lc++"
    on_linux do
      cxx_lib = "-lstdc++"
    end

    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"
  end
end
