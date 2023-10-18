class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.41.tar.bz2"
  sha256 "13f3291007a5e8546fcb7bc0c6610ce44aaa9b3995059d4f8145ba09fd5be3e1"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7f0efbe239c4226b8b56ab44d5880e69318df8d6d5f3f34ee5994d65073fed23"
    sha256 arm64_ventura:  "5789285b2a977cf20b61a346fcf44f5260a20af5432d0cc62732a89609e3c828"
    sha256 arm64_monterey: "e21c9ae6576afb03b728ed48a4a5a2458bf23cff71944d5f93939d02cca148ee"
    sha256 arm64_big_sur:  "8fd172c5b153ea13239e921c186329218be6d4506ff4e91167753c756dc1d92c"
    sha256 sonoma:         "a033569e3c2b8d075e43d039bfb5c28187619a2116da6da81b63659d3f67148a"
    sha256 ventura:        "35a9d856bd6a1abe7585291295883d3f68d54076af55e881fc0356bcdbd84f88"
    sha256 monterey:       "1ded70c04491779a692124ff3530e75bff9ed48a0d1d5d4448a03ac59424b3bb"
    sha256 big_sur:        "00c4f5f0629f45826b4c1c163596c32f13e726c24c85149eb34267901ca0ad10"
    sha256 x86_64_linux:   "e407d01641735fdeeb789ca26ee6dc4d8dfd445202c9612316981d5209314901"
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
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

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
