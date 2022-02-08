class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.34.tar.bz2"
  sha256 "562a3350dcf66cb67c5825c67ff2c2904db1e30ec8e1d353adc14efba9abf43f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "53ab35b6a092a7846d0fa8409f540f712d5b6d7044e0b0d8b762087e6c640ced"
    sha256 arm64_big_sur:  "2037c66b74dfb1a2d7c6e30df4b19c10b7da5e8f338fd0bc5b433512dc6ac306"
    sha256 monterey:       "0d476bc63d4f8defb02dc2b9b33f4112ef4fd16e3c19ac86ca9208cc74abc13b"
    sha256 big_sur:        "e541cba8dac2fd43727e0119a7e0f6dd04c2a28888a791454cf44dddd1884c32"
    sha256 catalina:       "84775ab011fd99aa15ceb4bee9f202307f3a40c340deec2e928ddcb18eec275b"
    sha256 x86_64_linux:   "b6d822a10eacd0895226707ce62f5e2ddc9880a6ee618f46559c7ec452215933"
  end

  keg_only :versioned_formula

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

  uses_from_macos "sqlite" => :build

  on_linux do
    depends_on "libidn"
  end

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
