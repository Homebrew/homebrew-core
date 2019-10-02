class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.4.0.tar.gz"
  sha256 "4904c5ea7914a58f60a5e2fbc397be67e7a25c380d7d07c1c31a3eefff1c92f1"

  bottle do
    cellar :any
    sha256 "253c51ec98e9bd038d47d8482ea15e85183cc8dd718e5cf41facdfe9555f3717" => :catalina
    sha256 "111658d105dc894ea67e1fdc98597c73c1bf1fa64ac52f1287372ded53a1cdab" => :mojave
    sha256 "5673dfdc40bfc3f3495ec2fcff9ea5d5b65b244940f5bf686f79b838b97fdf3d" => :high_sierra
    sha256 "1418b449d38fbe7f37071ab6bf8f383d53d3540d41597be97eefdcc08749b7e3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  # from https://github.com/openexr/openexr/commit/0b26a9dedda4924841323677f1ce0bce37bfbeb4.patch
  patch :DATA

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end

__END__
diff --git a/OpenEXR/config/CMakeLists.txt b/OpenEXR/config/CMakeLists.txt
index 1ef829a2..8d6d7ac8 100644
--- a/OpenEXR/config/CMakeLists.txt
+++ b/OpenEXR/config/CMakeLists.txt
@@ -72,9 +72,9 @@ if(OPENEXR_INSTALL_PKG_CONFIG)
   # use a helper function to avoid variable pollution, but pretty simple
   function(openexr_pkg_config_help pcinfile)
     set(prefix ${CMAKE_INSTALL_PREFIX})
-    set(exec_prefix ${CMAKE_INSTALL_BINDIR})
-    set(libdir ${CMAKE_INSTALL_LIBDIR})
-    set(includedir ${CMAKE_INSTALL_INCLUDEDIR})
+    set(exec_prefix "\${prefix}")
+    set(libdir "\${exec_prefix}/${CMAKE_INSTALL_LIBDIR}")
+    set(includedir "\${prefix}/${CMAKE_INSTALL_INCLUDEDIR}")
     set(LIB_SUFFIX_DASH ${OPENEXR_LIB_SUFFIX})
     if(TARGET Threads::Threads)
       # hrm, can't use properties as they end up as generator expressions
