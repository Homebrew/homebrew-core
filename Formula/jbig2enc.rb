class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  revision 2

  stable do
    url "https://github.com/agl/jbig2enc/archive/0.28-dist.tar.gz"
    sha256 "83e71ce2d27ba845058b9f9fefc6c5586c7731fdac8709611e4f49f271a580f1"
    version "0.28"

    # Patch data from https://github.com/agl/jbig2enc/commit/53ce5fe7e73d7ed95c9e12b52dd4984723f865fa
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "315628bfa534b889464d704b643b52bd435d40e3038cc58cfadf45a6b7aee055" => :sierra
    sha256 "eec8c01f0971a8302807b09ddd1ee60b59985d386ae38934448f21f739f91f5a" => :el_capitan
    sha256 "011e7d097afbdfc679490d42912a21cbe686af65eb9bfb309bb4c52cdfb97cb0" => :yosemite
    sha256 "c11501919336351d471abb7445bce4b984fd5a59a87b2c0c159b2517b7724708" => :mavericks
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
