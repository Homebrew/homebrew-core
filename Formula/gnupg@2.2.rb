class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.32.tar.bz2"
  sha256 "b2571b35f82c63e7d278aa6a1add0d73453dc14d3f0854be490c844fca7e0614"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a4c726e2530a082a42b16537c7c842bc930869c5901b848363aa82a8e4605fc0"
    sha256 arm64_big_sur:  "d5b237d03383aad0b7c389a1687808afe9935e0b82b3de8a57e144c42046cb25"
    sha256 monterey:       "8b5648cefe2233296224da83f0e6a3ad3e31bd8727332c520572a9f8c42d5e72"
    sha256 big_sur:        "97bc5ab5fbed07d57d0a5520ca821fcd7d229d515794ef549bef13d94995c8b6"
    sha256 catalina:       "9a70625ba7a01abdbf898fa07df18eaabf7ec2737185fbe094fb629494e0916a"
    sha256 mojave:         "2e3786d7d40b82eeee785c4a4063705110930b22d6282bbf3634ad2e3e358af7"
    sha256 x86_64_linux:   "64ee92a2cb821ace17056b912d41ecc48cac0e8d3fbdc45742d82b3c65b546d3"
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
