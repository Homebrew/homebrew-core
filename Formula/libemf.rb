class Libemf < Formula
  desc "Library implementation of ECMA-234 API for the generation of enhanced metafiles"
  homepage "https://libemf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libemf/libemf/1.0.13/libemf-1.0.13.tar.gz"
  sha256 "74d92c017e8beb41730a8be07c2c6e4ff6547660c84bf91f832d8f325dd0cf82"
  license "LGPL-2.1-or-later"

  # patch for missing byteswap.h on macOS
  patch :DATA

  def install
    ENV.append "CXX", "-std=c++14"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libEMF/emf.h>
      int main() {
        HENHMETAFILE metafile;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{include}", "-L#{lib}", "-lemf", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/libemf/libemf.cpp b/libemf/libemf.cpp
index 2060f0d..4b77be5 100644
--- a/libemf/libemf.cpp
+++ b/libemf/libemf.cpp
@@ -72,7 +72,11 @@ namespace EMF {
     if ( not bigEndian() ) {
       return a;
     }
+#if defined(__APPLE__)
+#define bswap_32(x) _OSSwapInt32(x)
+#else
 #include <byteswap.h>
+#endif
     return bswap_32(a);
   }
