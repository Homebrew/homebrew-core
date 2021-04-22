class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.1.tar.bz2"
  sha256 "c498db346a9b9a4b399e514c8f56dfc0a888ce8f327f10376ff984452cd154ec"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "dfcafec11417b6ba95ee301c1507ed87b5b7251df546e143f1a5bdedd65b4673"
    sha256 big_sur:       "675fbedff1eaddf91c6b0dd547390604c561c65de4af91a0810dc326a9079e6d"
    sha256 catalina:      "eead46a35c3fde2b33c8c6a1ed825a0e474923c97e28dda4a1a92c3f3fefc93b"
    sha256 mojave:        "ed045a3ec35171c7183b23b28868489a258d119033caf395dee54ab2268332b2"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"

  uses_from_macos "sqlite", since: :catalina

  on_linux do
    depends_on "libidn"
  end

  # Fix tests for gnupg 2.3.1, remove in the next release
  # Patch ref: https://dev.gnupg.org/rGd36c4dc95b72b780375d57311bdf4ae842fd54fa
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

__END__
diff --git a/tests/openpgp/defs.scm b/tests/openpgp/defs.scm
index 768d479aa..86d312f82 100644
--- a/tests/openpgp/defs.scm
+++ b/tests/openpgp/defs.scm
@@ -338,6 +338,7 @@
   (create-file "common.conf"
 	       (if (flag "--use-keyboxd" *args*)
 		   "use-keyboxd" "#use-keyboxd")
+	       (string-append "keyboxd-program " (tool 'keyboxd))
 	       )

   (create-file "gpg.conf"
