class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.3.tar.bz2"
  sha256 "5789b86da6a1a6752efb38598f16a77af51170a8494039c3842b085032e8e937"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7935ce2295cc17a978ad5d00c0cb34f2969c510e8820f1404f44fd7d3bd585b0"
    sha256 arm64_big_sur:  "e1f444e61d3e8c00970d2e61d513caf02ab4b2c07c2bd8a2b13dd8265e4c379a"
    sha256 monterey:       "054b5d03dc3b3e3fb71ec3f8b4c39e250bde24ac4981c5f2c041567e5643be90"
    sha256 big_sur:        "3854d1939e38f51eee0d471dbb86be5880c583fc43099e04f11b7538318606e0"
    sha256 catalina:       "a810862dacc767bcece54292cf27854d96c10f028b6fee3bc0ea421aebe8c334"
    sha256 x86_64_linux:   "05705f2461335835103d19f0451222e129dac8f05c4c8d3e972dba30a119558d"
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

  # Silence warning about /proc.
  # Remove with the next release.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/890be5f6af88e7913d177af87a50129049e681bb/gnupg/2.3.3-proc-error.patch"
    sha256 "c4ee02929a03935121b8a2db01e83fbe046a07f104514b2d1cba453c47464204"
  end

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
    if OS.mac?
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~EOS
        disable-ccid
      EOS
      pkgetc.install "scdaemon.conf"
    end
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
