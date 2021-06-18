class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.1.tar.bz2"
  sha256 "c498db346a9b9a4b399e514c8f56dfc0a888ce8f327f10376ff984452cd154ec"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "fd27ef93bf469e8f5689c372f6b6dba70f2fb777b8056b22e5688b67a146b902"
    sha256 big_sur:       "d1459dc52e4360dd6d812a833218e5ced1f08c10b131981a3ec2aab9fc5d7f9c"
    sha256 catalina:      "fbdc50f45c45b3444b7d4dd48334e91b8a0c9dbf84da85f379981bbb2ee1a5a3"
    sha256 mojave:        "bbbcdf26abc4cb46557b59ba60320317d457e7f794ed3092891df29153b5d807"
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

    # Configure scdaemon as recommended by upstream developers
    # https://dev.gnupg.org/T5415#145864
    on_macos do
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~EOS
        disable-ccid
      EOS
      pkgetc.install "scdaemon.conf"
    end
  end

  def post_install
    (var/"run").mkpath
    quiet_system "gpgconf", "--reload", "all"
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
