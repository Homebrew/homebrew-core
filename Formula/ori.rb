class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.2.tar.xz"
  sha256 "a9b12ac23beaf259aa830addea11b519d16068f38c479f916b2747644194672c"
  revision 2

  bottle do
    cellar :any
    sha256 "0a281c044b4fb7daa4bb1a63cacc4b95b7723ef9b8fe9a1b2a5d9e596347336b" => :mojave
    sha256 "967376d424f8e64e4658b789beec7913db66918824454dd7082642495b19b57e" => :high_sierra
    sha256 "04595e1ffa77c8f81e0c8f9b62aeebefff42d214600e6b34ce147276d0d99bbc" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on :osxfuse

  # Patch adapted from upstream for OpenSSL 1.1 compatibility
  # https://bitbucket.org/orifs/ori/pull-requests/7/adjust-to-libssl-api-changes-from-10-to-11/diff
  patch :DATA

  def install
    system "scons", "BUILDTYPE=RELEASE"
    system "scons", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
__END__
diff -pur ori-0.8.2/liboriutil/key.cc ori-0.8.2-fixed/liboriutil/key.cc
--- ori-0.8.2/liboriutil/key.cc	2019-01-28 02:12:19.000000000 +0100
+++ ori-0.8.2-fixed/liboriutil/key.cc	2019-09-07 10:01:36.000000000 +0200
@@ -131,7 +131,7 @@ PublicKey::verify(const string &blob,
                   const string &digest) const
 {
     int err;
-    EVP_MD_CTX * ctx = new EVP_MD_CTX(); // XXX: openssl 1.1+ EVP_MD_CTX_new();
+    EVP_MD_CTX * ctx = EVP_MD_CTX_new();
     if (!ctx) {
       throw system_error(ENOMEM, std::generic_category(), "Could not allocate EVP_MD_CTX");
       return false;
@@ -146,14 +146,14 @@ PublicKey::verify(const string &blob,
     if (err != 1)
     {
         ERR_print_errors_fp(stderr);
-        delete ctx; // XXX: openssl 1.1+ EVP_MD_CTX_free(ctx);
+        EVP_MD_CTX_free(ctx);
         throw exception();
         return false;
     }

     // Prepend 8-byte public key digest

-    delete ctx; // XXX: openssl 1.1+ EVP_MD_CTX_free(ctx);
+    EVP_MD_CTX_free(ctx);
     return true;
 }

@@ -191,7 +191,7 @@ PrivateKey::sign(const string &blob) con
     int err;
     unsigned int sigLen = SIGBUF_LEN;
     char sigBuf[SIGBUF_LEN];
-    EVP_MD_CTX * ctx = new EVP_MD_CTX(); // XXX: openssl 1.1+ EVP_MD_CTX_new();
+    EVP_MD_CTX * ctx = EVP_MD_CTX_new();
     if (!ctx) {
       throw system_error(ENOMEM, std::generic_category(), "Could not allocate EVP_MD_CTX");
     }
@@ -202,13 +202,13 @@ PrivateKey::sign(const string &blob) con
     if (err != 1)
     {
         ERR_print_errors_fp(stderr);
-        delete ctx; // XXX: openssl 1.1+ EVP_MD_CTX_free(ctx);
+        EVP_MD_CTX_free(ctx);
         throw exception();
     }

     // XXX: Prepend 8-byte public key digest

-    delete ctx; // XXX: openssl 1.1+ EVP_MD_CTX_free(ctx);
+    EVP_MD_CTX_free(ctx);
     return string().assign(sigBuf, sigLen);
 }
