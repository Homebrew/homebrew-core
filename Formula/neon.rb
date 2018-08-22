class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://web.archive.org/web/webdav.org/neon/"
  url "https://mirrorservice.org/sites/distfiles.macports.org/neon/neon-0.30.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.30.2.tar.gz"
  sha256 "db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca"

  bottle do
    cellar :any
    sha256 "804369c05d5d506da25ffeed64b7c7bbc136e9d9d685a788233937df898f5f10" => :mojave
    sha256 "6866235177ca4c311257547ca644e50a5011d5bb60ef3631cfb42a01a0fb7df9" => :high_sierra
    sha256 "6f44e5c1db3418612bf871f9551acef119162eac40585f045f02d2612ade356e" => :sierra
    sha256 "2aafd9bf8e7fb42d8cce9b6a7467e8beccc11931b824766e341a8d72331e0c48" => :el_capitan
    sha256 "7348fcda6d13a8cba37a98b7ac6c9876a2ffa037714954872832d390c5a475d7" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index d7702d2..5c3b5a3 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }

 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
