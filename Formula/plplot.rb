class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "http://plplot.sourceforge.net"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.11.1%20Source/plplot-5.11.1.tar.gz"
  sha256 "289dff828c440121e57b70538b3f0fb4056dc47159bc1819ea444321f2ff1c4c"

  bottle do
    rebuild 1
    sha256 "6681381c4376d45cf370df8a05936a045ccdcd15d8e44ad9a17d4ebafb3be442" => :sierra
    sha256 "bb79dcbf4b5bb7fdd82037f690ddf712673001ef8e6bd8d219b9bbacd93c216a" => :el_capitan
    sha256 "f0e0d7db60bb29f5f391cd93355b2cb987bc3582084fe384371b0e1bd8cc005c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "freetype"
  depends_on "libtool" => :run
  depends_on :x11 => :optional
  depends_on :fortran => :optional
  depends_on :java => :optional

  # Patches taken upstream
  # https://sourceforge.net/p/plplot/plplot/ci/11c496bebb2d23f86812c753e60e7a5b8bbfb0a0/
  # https://sourceforge.net/p/plplot/plplot/ci/cac0198537a260fcb413f7d97301979c2dfaa31c/
  # Remove both when next release is made available
  # CMake 3.6.x fix
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9d49869e/plplot/cmake-3.6.patch"
    sha256 "50b17ff7c80f24288f9eaeca256be0d9dd449e1f59cb933f442c8ecf812f999f"
  end

  # CMake 3.7.x fix
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b90fdc8f9a17f291bf3f2a33c25ffcc7ea85b31f/plplot/cmake-3.7.patch"
    sha256 "5c6cd338ca93637e5a4be5c0b3d479ca3211f1ebb456a1b51896b823d69fb992"
  end

  def install
    args = std_cmake_args
    args << "-DENABLE_java=OFF" if build.without? "java"
    args << "-DPLD_xwin=OFF" if build.without? "x11"
    args << "-DENABLE_f95=OFF" if build.without? "fortran"
    args += %w[
      -DENABLE_ada=OFF
      -DENABLE_d=OFF
      -DENABLE_qt=OFF
      -DENABLE_lua=OFF
      -DENABLE_tk=OFF
      -DENABLE_python=OFF
      -DENABLE_tcl=OFF
      -DPLD_xcairo=OFF
      -DPLD_wxwidgets=OFF
      -DENABLE_wxwidgets=OFF
    ]

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <plplot.h>

      int main(int argc, char *argv[]) {
        plparseopts( &argc, argv, PL_PARSE_FULL );
        plsdev( "extcairo" );
        plinit();
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/plplot
      -L#{lib}
      -lcsirocsa
      -lltdl
      -lm
      -lplplot
      -lqsastime
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
