class Mpg321 < Formula
  desc "Command-line MP3 player"
  homepage "http://mpg321.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpg321/mpg321/0.3.2/mpg321_0.3.2.orig.tar.gz"
  sha256 "056fcc03e3f5c5021ec74bb5053d32c4a3b89b4086478dcf81adae650eac284e"

  bottle do
    sha256 "a69f242f57e4211f96fa56f10573777204d5ed7d61cd7b35a04e0bbd33b9064e" => :sierra
    sha256 "6c8921b0703d2952b6038ce7097957c3c2bfe9b59c2d41b5caddc268e96b245d" => :el_capitan
    sha256 "48b9ac480d966fc344c4867f3dcef7cd59be1440b11fe7d8280d51134a881f78" => :yosemite
    sha256 "bf86f590672fdb27f6fc92c706db1bfcb2ca0a1e35129c5435821640a11a422f" => :mavericks
  end

  depends_on "mad"
  depends_on "libid3tag"
  depends_on "libao"

  # 1. Apple defines semun already. Skip redefining it to fix build errors.
  #    This is a homemade patch fashioned using deduction.
  # 2. Also a couple of IPV6 values are not defined on OSX that are needed.
  #    This patch was seen in the wild for an app called lscube:
  #       http://lscube.org/pipermail/lscube-commits/2009-March/000500.html
  # Both patches have been reported upstream here:
  # https://sourceforge.net/tracker/?func=detail&aid=3587769&group_id=36274&atid=416544
  # Remove these at: Unknown.  These have not been merged as of 0.3.2.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-mpg123-symlink",
                          "--enable-ipv6",
                          "--disable-alsa"
    system "make", "install"
  end
end

__END__
--- a/mpg321.h	2012-03-25 05:27:49.000000000 -0700
+++ b/mpg321.h	2012-11-15 20:54:28.000000000 -0800
@@ -290,7 +290,7 @@
 /* Shared total decoded frames */
 decoded_frames *Decoded_Frames;
 
-#if defined(__GNU_LIBRARY__) && !defined(_SEM_SEMUN_UNDEFINED)
+#if defined(__GNU_LIBRARY__) && !defined(_SEM_SEMUN_UNDEFINED) || defined(__APPLE__)
 /* */
 #else
 union semun {
--- a/network.c	2012-03-25 05:27:49.000000000 -0700
+++ b/network.c	2012-11-15 20:58:02.000000000 -0800
@@ -50,6 +50,13 @@
 
 #define IFVERB if(options.opt & MPG321_VERBOSE_PLAY)
 
+/* The following defines are needed to emulate the Linux interface on
+ * BSD-based systems like FreeBSD and OS X */
+#if !defined(IPV6_ADD_MEMBERSHIP) && defined(IPV6_JOIN_GROUP)
+#define IPV6_ADD_MEMBERSHIP IPV6_JOIN_GROUP
+#define IPV6_DROP_MEMBERSHIP IPV6_LEAVE_GROUP
+#endif
+
 int proxy_enable = 0;
 char *proxy_server;
 int auth_enable = 0;
