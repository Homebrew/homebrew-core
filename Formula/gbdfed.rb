class Gbdfed < Formula
  desc "Bitmap Font Editor"
  homepage "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/"
  url "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/gbdfed-1.6.tar.gz"
  sha256 "8042575d23a55a3c38192e67fcb5eafd8f7aa8d723012c374acb2e0a36022943"
  revision 1

  bottle do
    cellar :any
    sha256 "59f48f1bb6eca29530d74775ae09f845409f0b39416a866c8b9adcd7832819ea" => :sierra
    sha256 "9362dbaf834be1657f7984de06acfcc00ec29779b4c03738ad16731c5d91f41d" => :el_capitan
    sha256 "b511b3b460e70022e9dcb4750a042a9e488114173641859f04bb589363bb4fd0" => :yosemite
    sha256 "86762c5a866cf55625e323266661af05e66c37e18c1320d644a7627eee8ca416" => :mavericks
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
    assert (bin/"gbdfed").exist?
    assert (share/"man/man1/gbdfed.1").exist?
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
