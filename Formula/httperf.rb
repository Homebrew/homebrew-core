class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  revision 2

  bottle do
    cellar :any
    sha256 "80a2634adda8fe39ebda84ccdf6cbbb0357668da3615067b6f9714229801d085" => :catalina
    sha256 "390d46278c9e7bd0f58003ba49bc1a0ab110ab24864029d6ae9fd8d3f491b57c" => :mojave
    sha256 "5c049e4bfc272313e7c1051da7430bc09e712d5a70f1593c5ecf08ac94b3b238" => :high_sierra
    sha256 "015d2ce99b57fa808ae284f44904ca209e11603bf66085bf64a8270c45203490" => :sierra
  end

  head do
    url "https://github.com/httperf/httperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  # Upstream patch for OpenSSL 1.1 compatibility
  # https://github.com/httperf/httperf/pull/48
  patch :DATA

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/httperf", "--version"
  end
end
__END__
diff -pur httperf-0.9.0/src/core.c httperf-0.9.0-fixed/src/core.c
--- httperf-0.9.0/src/core.c	2007-04-07 09:01:56.000000000 +0200
+++ httperf-0.9.0-fixed/src/core.c	2019-09-11 14:12:54.000000000 +0200
@@ -805,8 +805,8 @@ core_ssl_connect (Conn *s)
	fprintf (stderr, "core_ssl_connect: server refused all client cipher "
		 "suites!\n");
       else
-	fprintf (stderr, "core_ssl_connect: cipher=%s, valid=%d, id=%lu\n",
-		 ssl_cipher->name, ssl_cipher->valid, ssl_cipher->id);
+	fprintf (stderr, "core_ssl_connect: cipher=%s, id=%lu\n",
+		 SSL_CIPHER_get_name(ssl_cipher), SSL_CIPHER_get_id(ssl_cipher));
     }

   arg.l = 0;
diff -pur httperf-0.9.0/src/httperf.c httperf-0.9.0-fixed/src/httperf.c
--- httperf-0.9.0/src/httperf.c	2007-04-07 09:01:56.000000000 +0200
+++ httperf-0.9.0-fixed/src/httperf.c	2019-09-11 14:12:54.000000000 +0200
@@ -808,7 +808,7 @@ main (int argc, char **argv)
       SSLeay_add_ssl_algorithms ();

       /* for some strange reason, SSLv23_client_method () doesn't work here */
-      ssl_ctx = SSL_CTX_new (SSLv3_client_method ());
+      ssl_ctx = SSL_CTX_new (TLS_client_method ());
       if (!ssl_ctx)
	{
	  ERR_print_errors_fp (stderr);
