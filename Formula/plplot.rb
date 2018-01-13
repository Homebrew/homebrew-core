class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.13.0%20Source/plplot-5.13.0.tar.gz"
  sha256 "ec36bbee8b03d9d1c98f8fd88f7dc3415560e559b53eb1aa991c2dcf61b25d2b"
  revision 1

  bottle do
    sha256 "d916ee384f86257d3584a27b42d0b164afd4667c23388f2eb243f5dde846e226" => :high_sierra
    sha256 "bfc8004765fbb0ea7378951e1cbf21e1512eba73528f219bbb85acc5fef9a85d" => :sierra
    sha256 "44fffbf81d69eb34c0746a646b2bab7d13c8c8aacab816d800e9d44ccb96762d" => :el_capitan
    sha256 "ac125db322d3a35450b1ff0e8f4c8ceb6221e0ab8a339887d2d3177dff3b3dbe" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libtool" => :run
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
                   "-lcsirocsa", "-lltdl", "-lm", "-lplplot", "-lqsastime"
    system "./test"
  end
end
