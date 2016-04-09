class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  revision 1

  stable do
    url "https://github.com/agl/jbig2enc/archive/0.28-dist.tar.gz"
    sha256 "83e71ce2d27ba845058b9f9fefc6c5586c7731fdac8709611e4f49f271a580f1"
    version "0.28"

    # Patch data from https://github.com/agl/jbig2enc/commit/53ce5fe7e73d7ed95c9e12b52dd4984723f865fa
    patch :DATA
  end
  bottle do
    cellar :any
    sha256 "41a5acbc72d2830e74690f979e902683ad0594bc50ee24339aacb83c03cccd44" => :el_capitan
    sha256 "d4bc377df69aab54e624982ba617c4ba970cc82229d7a01d6fda18491c8e97cf" => :yosemite
    sha256 "72935a0c1f1d543b0c1d0f915cb855a16dd2b7471a7ec0987108f8ac4a7c7390" => :mavericks
  end


  head do
    url "https://github.com/agl/jbig2enc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "leptonica"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index fe37c22..753a607 100644
--- a/configure.ac
+++ b/configure.ac
@@ -55,6 +55,7 @@ AC_CHECK_LIB([lept], [findFileFormatStream], [], [
 			echo "Error! Leptonica not detected."
 			exit -1
 			])
+AC_CHECK_FUNCS(expandBinaryPower2Low,,)
 # test for function - it should detect leptonica dependecies
 
 # Check for possible dependancies of leptonica.
diff --git a/src/jbig2.cc b/src/jbig2.cc
index e10f042..515c1ef 100644
--- a/src/jbig2.cc
+++ b/src/jbig2.cc
@@ -130,11 +130,16 @@ segment_image(PIX *pixb, PIX *piximg) {
   // input color image, so we have to do it this way...
   // is there a better way?
   // PIX *pixd = pixExpandBinary(pixd4, 4);
-  PIX *pixd = pixCreate(piximg->w, piximg->h, 1);
-  pixCopyResolution(pixd, piximg);
-  if (verbose) pixInfo(pixd, "mask image: ");
-  expandBinaryPower2Low(pixd->data, pixd->w, pixd->h, pixd->wpl,
+  PIX *pixd;
+#ifdef HAVE_EXPANDBINARYPOWER2LOW
+    pixd = pixCreate(piximg->w, piximg->h, 1);
+    pixCopyResolution(pixd, piximg);
+    expandBinaryPower2Low(pixd->data, pixd->w, pixd->h, pixd->wpl,
                         pixd4->data, pixd4->w, pixd4->h, pixd4->wpl, 4);
+#else
+    pixd = pixExpandBinaryPower2(pixd4, 4);
+#endif
+  if (verbose) pixInfo(pixd, "mask image: ");
 
   pixDestroy(&pixd4);
   pixDestroy(&pixsf4);
