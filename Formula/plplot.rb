class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.12.0%20Source/plplot-5.12.0.tar.gz"
  sha256 "8dc5da5ef80e4e19993d4c3ef2a84a24cc0e44a5dade83201fca7160a6d352ce"
  revision 1

  bottle do
    sha256 "aff26bde3a4da328de52e722694be91f598b63bae82b488e822aab7cdc0bce6a" => :sierra
    sha256 "2c8642a2496067a0c1a21fd58a6ce390096dc31d7aeb8930bbd0a97e4719e87e" => :el_capitan
    sha256 "6201a37bda814ab07ef18466b1cff2f4624254e6209534e7c2fff57649aee4a0" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "libtool" => :run
  depends_on "pango"
  depends_on :fortran
  depends_on :java => :optional
  depends_on :x11 => :optional

  # Patch reported upstream. Fixes 5.12 cmake issue in cmake/modules/pkg-config.cmake that gets
  # triggered when passing `--with-fortran`
  patch :DATA

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
    (testpath/"test.c").write <<-EOS.undent
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

__END__
diff --git i/cmake/modules/pkg-config.cmake w/cmake/modules/pkg-config.cmake
index 2b46dbe..7ecc789 100644
--- i/cmake/modules/pkg-config.cmake
+++ w/cmake/modules/pkg-config.cmake
@@ -230,7 +230,7 @@ function(pkg_config_link_flags link_flags_out link_flags_in)
     "/System/Library/Frameworks/([^ ]*)\\.framework"
     "-framework \\1"
     link_flags
-    ${link_flags}
+    "${link_flags}"
     )
     #message("(frameworks) link_flags = ${link_flags}")
   endif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
