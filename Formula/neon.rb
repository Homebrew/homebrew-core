class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.31.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.31.2.tar.gz"
  sha256 "cf1ee3ac27a215814a9c80803fcee4f0ede8466ebead40267a9bd115e16a8678"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "2257aace79050e66bd7c2de052d7506a0fdfbc62ba9b84ff2f87da6396aa22da" => :big_sur
    sha256 "59508df4cea7739d669187e923c1e3ceac1b3e65cbfbe6c1e5d38ef37bb65382" => :arm64_big_sur
    sha256 "08c046a121125fb4a2ec4e84035586aa46086aa07a0bbeb2f189ed7e597a6d67" => :catalina
    sha256 "20d474191273a8210f05ecb6ed300d6aa92ffccd6cc45d3ef1f12d8d58d5fee9" => :mojave
    sha256 "0bc378496a9a3c82f30909210acdd3ead44594dba78741797edabbec2b9481e8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}"
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
