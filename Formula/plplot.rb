class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.15.0%20Source/plplot-5.15.0.tar.gz"
  sha256 "b92de4d8f626a9b20c84fc94f4f6a9976edd76e33fb1eae44f6804bdcc628c7b"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "54b7f57eb347cd104a27d199b7a5bca36f01be5c0f5c837290c9efc19429d7bb" => :big_sur
    sha256 "1f9f1b0eb13535a59cd938e43ad1b190e08bbe5ebab222673421d41fd442cedc" => :arm64_big_sur
    sha256 "57046a10346c01ff487b1da3623ad21daf5452be29b2adfef0845db9e5f4a185" => :catalina
    sha256 "e89a7f7b82e127c5980077b96423c1a40f534bca789818ef4fc95f0b67dee34a" => :mojave
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
