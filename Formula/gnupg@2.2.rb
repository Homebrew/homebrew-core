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
    sha256 arm64_big_sur: "91b0dff7299d8ba7835cb511b17fb9000e27f9cfe347ea0b5deac0e0e599f8d8"
    sha256 big_sur:       "c1515eca53270b84dfc5dca8bcdb7b6da857cb167aa1a4292e5ec3c1e905c739"
    sha256 catalina:      "6f343a4c3c4ead308a6df0e20a5be640c326eadf2aae9b2621ee3297e9c4c1f6"
    sha256 mojave:        "ced2608b0f34f2ef6f609b25325b086b9d5da8fd6e1bce7942d5a59590a1c261"
    sha256 x86_64_linux:  "fd5bb6a47e65e3ad16c08778076beca083ca4ade8d8db912144632d6bd8e653f"
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
