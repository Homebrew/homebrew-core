class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.39.tar.bz2"
  sha256 "ab74db6685f026d7c0a10b527ecddecd608606a1691d15fda5d0a7f7d27e4c2f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "42ee5c8c7e3149d053d2240ee0b1713a3ffdfaad64e5f07670d1a06b39b6c69f"
    sha256 arm64_big_sur:  "a5ca695d2b2afabe3fce220349cafb753fdd842590e2956143608374abed0601"
    sha256 monterey:       "48716cd9872215b077b6b0520cee3cd2377396d8e6b754ad3f4486de05bb103d"
    sha256 big_sur:        "9770385e8c14f3e3dc899df6a4a912051def9ec5f78558b7a1bb87034626fd46"
    sha256 catalina:       "8eb692549e0d5de08be1e4d207fe56705dba61128017158733ffacde7de5fd46"
    sha256 x86_64_linux:   "7c3223ce6cf86a106da91b58c7eaaf45f0b8522affb4aaf1addc60202b76acbf"
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
