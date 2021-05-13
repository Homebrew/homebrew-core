class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/3.17.tar.gz"
  sha256 "baa642c906576d4d98d041d0acb80d85dd6eff6e3c16a009b1abf1ccd2bc0a61"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "945ddcfbc1826e3fd71e88a4f6b64917c20654022692fc6cc687e649d3c8bf0e"
    sha256 cellar: :any, big_sur:       "946daa961b764288a543f716ee6706f14f39bba63253a81f8d2f29b8a9ac428b"
    sha256 cellar: :any, catalina:      "db37ddd9a80b8b9ceff16485b0e2a443c241610346904b5e3579b857a4af7ce4"
    sha256 cellar: :any, mojave:        "5f28a83cf4c946380a82c7facfee88d1881f9ddefc2177811370747d6de06f1d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    double_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}/bullet_double
      -DUSE_DOUBLE_PRECISION=ON
    ]

    mkdir "builddbl" do
      system "cmake", "..", *double_args, *common_args
      system "make", "install"
    end
    dbllibs = lib.children
    (lib/"bullet_double").install dbllibs

    args = std_cmake_args + %W[
      -DBUILD_PYBULLET=ON
      -DBUILD_PYBULLET_NUMPY=ON
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=ON"
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

    # Test single-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    # Test double-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}/bullet_double",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"
  end
end
