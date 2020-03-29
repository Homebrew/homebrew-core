class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.20.tar.bz2"
  sha256 "04a7c9d48b74c399168ee8270e548588ddbe52218c337703d7f06373d326ca30"

  bottle do
    sha256 "527ac31afe998a9931a6648c6fcc7288462ae73d6e6e8b84ecf46561c82d50ec" => :catalina
    sha256 "e826cf4b1764da749eba007097be8077f433e52d8f96405044e57a384b114942" => :mojave
    sha256 "179b68a29fe9f6731a294a674fbd439623acf22c1997c68b6358808adc83b763" => :high_sierra
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
