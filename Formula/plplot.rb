class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.13.0%20Source/plplot-5.13.0.tar.gz"
  sha256 "ec36bbee8b03d9d1c98f8fd88f7dc3415560e559b53eb1aa991c2dcf61b25d2b"
  revision 3

  bottle do
    sha256 "e24c2336dc62c973e9d80552790b8273b1a3d3b78b7a50cc28b4efb07960abd8" => :high_sierra
    sha256 "f0b74862d8cd905b51ec1bca32c38bcae6dfb1cd85cfc278a146fa7c0d7fad7d" => :sierra
    sha256 "0e2e7324cec94dcb4d155c955c6423de01ddff1304ef49852d23b01fc38f1005" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "pango"
  depends_on :java => :optional
  depends_on :x11 => :optional

  def install
    args = std_cmake_args + %w[
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
      -DENABLE_DYNDRIVERS=OFF
    ]
    args << "-DENABLE_java=OFF" if build.without? "java"
    args << "-DPLD_xwin=OFF" if build.without? "x11"

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <plplot.h>
      int main(int argc, char *argv[]) {
        plparseopts(&argc, argv, PL_PARSE_FULL);
        plsdev("extcairo");
        plinit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/plplot", "-L#{lib}",
                   "-lcsirocsa", "-lm", "-lplplot", "-lqsastime"
    system "./test"
  end
end
