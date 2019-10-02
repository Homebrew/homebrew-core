class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.4.0.tar.gz"
  sha256 "4904c5ea7914a58f60a5e2fbc397be67e7a25c380d7d07c1c31a3eefff1c92f1"

  bottle do
    cellar :any
    sha256 "d08e79f3a1e2875adba8c7affb929ac6fcdff93a66646a7f8c094263152912e4" => :catalina
    sha256 "436dbe30d0bc520c5c056dac23a3558dd2595e5f5b68c6c17e18566716c71e56" => :mojave
    sha256 "4ef6417909dee0313b9d493b5689d04382907beb650abc669fc5a6346e4c4d5b" => :high_sierra
    sha256 "f81d4a8993861dbde4c91b0783b03a943c710c060b938095511f3cf26beee589" => :sierra
  end

  depends_on "cmake" => :build

  # From https://github.com/openexr/openexr/commit/0b26a9dedda4924841323677f1ce0bce37bfbeb4.patch
  patch :DATA

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
      pkgshare.install %w[Half HalfTest Iex IexMath IexTest IlmThread Imath ImathTest]
    end
  end

  test do
    cd pkgshare/"IexTest" do
      system ENV.cxx, "-I#{include}/OpenEXR", "-I./", "-c",
             "testBaseExc.cpp", "-o", testpath/"test"
    end
  end
end

__END__
diff --git a/IlmBase/config/CMakeLists.txt b/IlmBase/config/CMakeLists.txt
index 508176a4..a6bff04a 100644
--- a/IlmBase/config/CMakeLists.txt
+++ b/IlmBase/config/CMakeLists.txt
@@ -71,9 +71,9 @@ if(ILMBASE_INSTALL_PKG_CONFIG)
   # use a helper function to avoid variable pollution, but pretty simple
   function(ilmbase_pkg_config_help pcinfile)
     set(prefix ${CMAKE_INSTALL_PREFIX})
-    set(exec_prefix ${CMAKE_INSTALL_BINDIR})
-    set(libdir ${CMAKE_INSTALL_LIBDIR})
-    set(includedir ${CMAKE_INSTALL_INCLUDEDIR})
+    set(exec_prefix "\${prefix}")
+    set(libdir "\${exec_prefix}/${CMAKE_INSTALL_LIBDIR}")
+    set(includedir "\${prefix}/${CMAKE_INSTALL_INCLUDEDIR}")
     set(LIB_SUFFIX_DASH ${ILMBASE_LIB_SUFFIX})
     if(TARGET Threads::Threads)
       # hrm, can't use properties as they end up as generator expressions
