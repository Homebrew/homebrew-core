class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.15.0%20Source/plplot-5.15.0.tar.gz"
  sha256 "b92de4d8f626a9b20c84fc94f4f6a9976edd76e33fb1eae44f6804bdcc628c7b"
  revision 1

  bottle do
    sha256 "c9787b7555f0ccf504bdf2a457fb52699b03ecdacf09bd743f1b69158e556f75" => :mojave
    sha256 "c359058b80b9607c1dcae070f96f2fde9c080bdc7ba9903f9afcdb16a6388c77" => :high_sierra
    sha256 "bf4193d1d8f9beee8beb8163612df7a997b206dd8a97c5ab56265351d2ad84b4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "pango"

  def install
    args = std_cmake_args + %w[
      -DPL_HAVE_QHULL=OFF
      -DENABLE_ada=OFF
      -DENABLE_d=OFF
      -DENABLE_octave=OFF
      -DENABLE_qt=OFF
      -DENABLE_lua=OFF
      -DENABLE_tk=OFF
      -DENABLE_python=OFF
      -DENABLE_tcl=OFF
      -DPLD_xcairo=OFF
      -DPLD_wxwidgets=OFF
      -DENABLE_wxwidgets=OFF
      -DENABLE_DYNDRIVERS=OFF
      -DENABLE_java=OFF
      -DPLD_xwin=OFF
    ]

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # fix rpaths
    cd (lib.to_s) do
      Dir["*.dylib"].select { |f| File.ftype(f) == "file" }.each do |f|
        MachO::Tools.dylibs(f).select { |d| d.start_with?("@rpath") }.each do |d|
          d_new = d.sub("@rpath", opt_lib.to_s)
          MachO::Tools.change_install_name(f, d, d_new)
        end
      end
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
