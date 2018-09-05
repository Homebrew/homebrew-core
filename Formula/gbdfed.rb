class Gbdfed < Formula
  desc "Bitmap Font Editor"
  homepage "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/"
  url "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/gbdfed-1.6.tar.gz"
  sha256 "8042575d23a55a3c38192e67fcb5eafd8f7aa8d723012c374acb2e0a36022943"
  revision 2

  bottle do
    cellar :any
    sha256 "16029c834d4dffd8ce32cbf58c50d77818b27eb598cab70913c8e3765ac02472" => :mojave
    sha256 "5b4319ca75f1018403e0d2cc8db794d18b317d0cfee6270e6400fa2e4fb9b87f" => :high_sierra
    sha256 "14cb0338597a0c954308d2011a422239005d6ab36f80f2488d71972932bc1d3d" => :sierra
    sha256 "621e5fb3c02c63cff8490b7d104d397b19b9512bdab94217d07f7f5319de1159" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  # Fixes compilation error with gtk+ per note on the project homepage.
  patch :DATA

  def install
    # BDF_NO_X11 has to be defined to avoid X11 headers from being included
    ENV["CPPFLAGS"] = "-DBDF_NO_X11"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    assert_predicate bin/"gbdfed", :exist?
    assert_predicate share/"man/man1/gbdfed.1", :exist?
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index b482958..10a528e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -28,8 +28,7 @@ CC = @CC@
 CFLAGS = @XX_CFLAGS@ @CFLAGS@
 
 DEFINES = @DEFINES@ -DG_DISABLE_DEPRECATED \
-	-DGDK_DISABLE_DEPRECATED -DGDK_PIXBUF_DISABLE_DEPRECATED \
-	-DGTK_DISABLE_DEPRECATED
+	-DGDK_PIXBUF_DISABLE_DEPRECATED
 
 SRCS = bdf.c \
        bdfcons.c \
