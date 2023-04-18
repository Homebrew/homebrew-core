class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.15.0%20Source/plplot-5.15.0.tar.gz"
  sha256 "b92de4d8f626a9b20c84fc94f4f6a9976edd76e33fb1eae44f6804bdcc628c7b"
  revision 4

  bottle do
    sha256 arm64_ventura:  "486576902b6d2b2e587234bfdaecfc7ee5a58b3f50bf8d622ead6eee8952c091"
    sha256 arm64_monterey: "c9a7891722c17ce0ac1243e1400583ff61250a3ede6a1d232c2a6c9aa4a98178"
    sha256 arm64_big_sur:  "148662ac1efb63325a193e069fb65bed3ccee4c0288613d819c4f821ec3d8ba8"
    sha256 ventura:        "4e805b3ba1621186f2fae3e8d2f117915fdfbac9aaaf90678f0676f51956f584"
    sha256 monterey:       "a2da58214519cf354a3e0e6d5e40b3d2b3e7e0fc654701e8d0fe0520b95f7c9d"
    sha256 big_sur:        "840dc348629f2e2c23697475587ccc48822c4ad710b5497319340de6d3c6e401"
    sha256 catalina:       "9edc31f3d0fccb7d70c782da8ebd425cca7e332d4adcd1550e5ff7ed4c67b4f1"
    sha256 x86_64_linux:   "2bce940b801bd4cf968b7c7a3e220ce1f80ee3c29f6fac58d38de1151669b144"
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
