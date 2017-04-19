class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.86.1.tar.gz"
  sha256 "c058b2e4321ba6adaa656976c1a138c07b18fc03b29f5b82880d5d8228fbf059"
  revision 1

  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efdd2f02421a95c3a399962081ad5209f100825fd1c675e25b4d96693ef9252d" => :sierra
    sha256 "1aab6c634c6f175667f5e71a2d4221be160decb50b96f7d70e001f5fb495d433" => :el_capitan
    sha256 "71dcb0c8432c3d066bf349c8501f22c30d9ef179115cf4ed93422e75827dcef9" => :yosemite
  end

  option "with-framework", "Build frameworks"
  option "with-demo", "Build demo applications"
  option "with-double-precision", "Use double precision"

  deprecated_option "framework" => "with-framework"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "double-precision" => "with-double-precision"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DINSTALL_EXTRA_LIBS=ON -DBUILD_UNIT_TESTS=OFF
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
    args_static << "-DBUILD_BULLET2_DEMOS=OFF" if build.without? "demo"

    system "cmake", ".", *args_shared
    system "make", "install"

    system "make", "clean"

    system "cmake", ".", *args_static
    system "make", "install"

    prefix.install "examples" if build.with? "demo"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
