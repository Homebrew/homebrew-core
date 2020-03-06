class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.4.1.tar.gz"
  sha256 "3ebbe9a8e67edb4a25890b98c598e9fe23b10f96d1416d6a3ff0732e99d001c1"

  bottle do
    sha256 "8d0035149642480ce6f2cf7ef7e41505ceee657a39f57e3393c6c7a0faa29b2e" => :catalina
    sha256 "f0503503f7f34a3dba50983fc284f920407b7c4a83de36326157cf7b6fcd8660" => :mojave
    sha256 "f2c91954b76f5fd043195cae4ee117fe2d6e0563ebed99a7eefd82af5ea385a5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

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
