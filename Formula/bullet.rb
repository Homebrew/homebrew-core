class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/2.87.tar.gz"
  sha256 "438c151c48840fe3f902ec260d9496f8beb26dba4b17769a4a53212903935f95"
  revision 1
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "4e3b53253b5bdc5f075c5e9d63e3b3ab21e16eb90da57f13051d9beb80cdd6ae" => :mojave
    sha256 "67ebb227d1add969049c669c21436f6b10b8054d312771f9d796ddadaf8a918b" => :high_sierra
    sha256 "1b6bdf19a76d98b448c6768edfe7d7340df249aadea6d841226bd4b86c25173b" => :sierra
    sha256 "40daef7c06fe9352e96a60b6ea5abb7177484f2fb14e0bff505bb88f73a8186d" => :el_capitan
  end

  option "with-framework", "Build frameworks"
  option "with-demo", "Build demo applications"
  option "with-double-precision", "Use double precision"

  deprecated_option "framework" => "with-framework"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "double-precision" => "with-double-precision"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %W[
      -DINSTALL_EXTRA_LIBS=ON -DBUILD_UNIT_TESTS=OFF -DBUILD_PYBULLET=OFF
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]
    args << "-DUSE_DOUBLE_PRECISION=ON" if build.with? "double-precision"

    args_shared = args.dup + %w[
      -DBUILD_BULLET2_DEMOS=OFF -DBUILD_SHARED_LIBS=ON
    ]

    args_framework = %W[
      -DFRAMEWORK=ON
      -DCMAKE_INSTALL_PREFIX=#{frameworks}
      -DCMAKE_INSTALL_NAME_DIR=#{frameworks}
    ]

    args_shared += args_framework if build.with? "framework"

    args_static = args.dup << "-DBUILD_SHARED_LIBS=OFF"
    if build.without? "demo"
      args_static << "-DBUILD_BULLET2_DEMOS=OFF"
    else
      args_static << "-DBUILD_BULLET2_DEMOS=ON"
    end

    mkdir "build" do
      system "cmake", "..", *args_shared
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args_static
      system "make", "install"

      if build.with? "demo"
        rm_rf Dir["examples/**/Makefile", "examples/**/*.cmake", "examples/**/CMakeFiles"]
        pkgshare.install "examples"
        (pkgshare/"examples").install "../data"
      end
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

    if build.with? "framework"
      system ENV.cc, "test.cpp", "-F#{frameworks}", "-framework", "LinearMath",
                     "-I#{frameworks}/LinearMath.framework/Headers", "-lc++",
                     "-o", "f_test"
      system "./f_test"
    end

    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end
