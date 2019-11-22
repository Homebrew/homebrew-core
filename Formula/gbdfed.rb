class Gbdfed < Formula
  desc "Bitmap Font Editor"
  homepage "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/"
  url "http://sofia.nmsu.edu/~mleisher/Software/gbdfed/gbdfed-1.6.tar.gz"
  sha256 "8042575d23a55a3c38192e67fcb5eafd8f7aa8d723012c374acb2e0a36022943"
  revision 3

  bottle do
    cellar :any
    sha256 "ac131ff87dd812928b3f8136d5ce364370ab0a8ded3ffdf2fbf2a38e58998494" => :catalina
    sha256 "00b2376a043f6e90d777bc9e5805d84da21c046f446c4dcd649b482a01cbc6cf" => :mojave
    sha256 "945fc3ffa7573224e7a387e6dec353ca7f3b46829f3e3728774a97c26fb0923a" => :high_sierra
    sha256 "e32f2b72805a1dbe768f85e33ea10c0b603789f9101b21e0fbc750ab077a12e5" => :sierra
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
