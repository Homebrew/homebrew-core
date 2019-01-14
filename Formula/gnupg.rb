class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.12.tar.bz2"
  sha256 "db030f8b4c98640e91300d36d516f1f4f8fe09514a94ea9fc7411ee1a34082cb"

  bottle do
    sha256 "24059d53a3cf368f1f385a872128a9abb27210238caa829fc4b811023aa26148" => :mojave
    sha256 "5e115ff184403643a7f23c2ed0847aa0e25cbaae17845fe4b104b7afddcfac50" => :high_sierra
    sha256 "a34544f51c4240b6b1621c1b83b881c7d70a6107d85b826c5f4693d92e9ab0a0" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite" => :build if MacOS.version == :mavericks
  depends_on "adns"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--enable-all-tests",
                          "--enable-symcryptrun",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  def caveats; <<~EOS
    Once you run this version of gpg you may find it difficult to return to using
    a prior 1.4.x or 2.0.x. Most notably the prior versions will not automatically
    know about new secret keys created or imported by this version. We recommend
    creating a backup of your `~/.gnupg` prior to first use.

    For full details on each change and how it could impact you please see
      https://www.gnupg.org/faq/whats-new-in-2.1.html
  EOS
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
