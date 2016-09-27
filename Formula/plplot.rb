class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "http://plplot.sourceforge.net"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.11.1%20Source/plplot-5.11.1.tar.gz"
  sha256 "289dff828c440121e57b70538b3f0fb4056dc47159bc1819ea444321f2ff1c4c"

  bottle do
    sha256 "7aa599004d76405dda00f854cfff576b8414864011b6be37059591ae1ae1808c" => :sierra
    sha256 "1a0ebd2560517328652cce3600af9c715da25aa461cb21a621c2dbb9904f0c16" => :el_capitan
    sha256 "81eb90e08ac42f6f5ea9f41159baf2cbf95f93f6f1390ddd1b12f00bb415e079" => :yosemite
    sha256 "7e4c364b66c61d7f35cb6a5417ee5ef1d06fe7a30d78b8d237a36b4beaa458f8" => :mavericks
    sha256 "b779762659e485d6c9cad54206b1e72f2db5e82950b19a356439e9ce3ef79138" => :mountain_lion
  end

  option "with-java"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on "libtool" => :run
  depends_on "freetype"
  depends_on :x11 => :optional
  depends_on :fortran => :optional

  # Patches taken upstream
  # https://sourceforge.net/p/plplot/plplot/ci/11c496bebb2d23f86812c753e60e7a5b8bbfb0a0/
  # https://sourceforge.net/p/plplot/plplot/ci/cac0198537a260fcb413f7d97301979c2dfaa31c/
  # Remove when next release is made available
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9d49869e/plplot/cmake-3.6.patch"
    sha256 "50b17ff7c80f24288f9eaeca256be0d9dd449e1f59cb933f442c8ecf812f999f"
  end

  def install
    args = std_cmake_args
    args << "-DENABLE_java=OFF" if build.without? "java"
    args << "-DPLD_xwin=OFF" if build.without? "x11"
    args << "-DENABLE_f95=OFF" if build.without? "fortran"
    args << "-DENABLE_ada=OFF" << "-DENABLE_d=OFF" << "-DENABLE_qt=OFF" \
         << "-DENABLE_lua=OFF" << "-DENABLE_tk=OFF" << "-DENABLE_python=OFF" \
         << "-DENABLE_tcl=OFF" << "-DPLD_xcairo=OFF" << "-DPLD_wxwidgets=OFF" \
         << "-DENABLE_wxwidgets=OFF"

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
