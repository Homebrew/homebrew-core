class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.40.tar.bz2"
  sha256 "1164b29a75e8ab93ea15033300149e1872a7ef6bdda3d7c78229a735f8204c28"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "29e32b17f03c4b318cdb346869fa1afb75cfce6a194f1fee12923707349aa913"
    sha256 arm64_monterey: "2fc972a6690b60a0b7da63177cda161fd0eb97ee09fcbb9ed01909f704e506b5"
    sha256 arm64_big_sur:  "5a393aaae5a88526982f86c300049bacadef7b66d0bb4d984ff0c2be8a5f1ae5"
    sha256 ventura:        "3eaadc3d36c89b17e7a346ad3a3aee13d8c89f7bf21b4c7837b2acb5102551b2"
    sha256 monterey:       "75731410dc3b38057fe2f62f5be5f6d7f1aef3cb17fbeeafb35ad9bdffa52a07"
    sha256 big_sur:        "36c80b6ef3ce0c3ed6b5bfc65a8019effc0302ace77ced88a31cf463d755961a"
    sha256 catalina:       "fef3446aee27be7a788e1047b442b3a084abd811471cf9ac94c82641f0703de7"
    sha256 x86_64_linux:   "0bc244f7c6e2b63e13d34590910e564f2efccf350d9f75afee3c2362ab34d892"
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

  # Fixes a build failure without ldap.
  # Committed upstream, will be in the next release.
  # https://dev.gnupg.org/T6239
  patch do
    url "https://dev.gnupg.org/rGa5c3821664886ffffbe6a83aac088a6e0088a607?diff=1"
    sha256 "41c633362f599fdc5a3d3b49f70831854ac881273aafbbc568ae4e87f4121782"
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
