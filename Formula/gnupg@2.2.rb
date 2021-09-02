class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.30.tar.bz2"
  sha256 "cc636d6e22a673993d94814c09be469df2ce27a0c66b1cab39bbab1786cf2184"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a7e5ac5ae865382190ec5fa7c6b6b0ef2abaee1bda949074dbee41500d48e9d9"
    sha256 big_sur:       "9c62310955d92e2d226a53e545d4419e7404109b75972dee8bcdd2b6ab64a4e7"
    sha256 catalina:      "8613f0020417b185db21aa7be556aef7cfacc4c6b07f21083bbee2770ae1f8b4"
    sha256 mojave:        "43f2a5ca049960284a7434b6c6ec4c09f7782fa9f13af7878dacf2d142caa1f9"
    sha256 x86_64_linux:  "57eb2151612b2a32102ae2c3a48e11c0cee53b528b884e164e1bc0ccf7c90566"
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
