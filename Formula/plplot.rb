class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.15.0%20Source/plplot-5.15.0.tar.gz"
  sha256 "b92de4d8f626a9b20c84fc94f4f6a9976edd76e33fb1eae44f6804bdcc628c7b"
  revision 3

  bottle do
    sha256 arm64_monterey: "1cfe623096b2cff3c653cf9c99952615023ce2243e0ffd2e568e2f0ada54174c"
    sha256 arm64_big_sur:  "8d088f536d53da047d2031923ef00ceaa57745c80fa59913b1bebe89b2f3b1b7"
    sha256 monterey:       "d9b7ea973efc0112daf0b647c1601035126c4255a205d1740925938d1bb008f6"
    sha256 big_sur:        "68234fbf98737c25674da67d4a207a52bb19119e3e71eaf6d4e5948167502fc5"
    sha256 catalina:       "3f1ac3dcde8f3eec89b1abc4237e0eb386a2e8c72f08515c52f185e083fd3c73"
    sha256 mojave:         "6adc5277a905f281ec0498843ecfcf16a6300fa656f749173ac7c8af28dab157"
    sha256 x86_64_linux:   "61fcc3fc9e8109fe643af6a9f4367ff5e8c20fb77cb0754b6ee074fad5af33c2"
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

    # std_cmake_args tries to set CMAKE_INSTALL_LIBDIR to a prefix-relative
    # directory, but plplot's cmake scripts don't like that
    args.map! { |x| x.start_with?("-DCMAKE_INSTALL_LIBDIR=") ? "-DCMAKE_INSTALL_LIBDIR=#{lib}" : x }

    # Also make sure it already exists:
    lib.mkdir

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      # These example files end up with references to the Homebrew build
      # shims unless we tweak them:
      inreplace "examples/c/Makefile.examples", %r{^CC = .*/}, "CC = "
      inreplace "examples/c++/Makefile.examples", %r{^CXX = .*/}, "CXX = "
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
