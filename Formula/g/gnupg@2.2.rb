class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.42.tar.bz2"
  sha256 "9189fbd4ec83ad243a4e499d5cb7fe72e4532176817e5ea880ed36a71dd82557"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "83c9b7ba74cb3ed47c5d7775f44e3cce574bc00ac32b2852c0e80b9be9055f4e"
    sha256 arm64_ventura:  "e58689943ae78a9483d9ab3a0cc4f7a3a8b6111276617b5d627794c16a2f6aec"
    sha256 arm64_monterey: "a733eb7a0f524ef05ee61ad23748afe7c327dfec660fe4be326806927b6a78c2"
    sha256 sonoma:         "da511f4778f0ff8032c4a0bfa071a3ed0f10dceb96bae18c3998e00d2f48486c"
    sha256 ventura:        "4cd401d4239527176412d2a10b51633e96ec73f58ce56610afc0b1d9668f3daa"
    sha256 monterey:       "11e00240af349e7cbf4e591196bc13c3f71359373d30b65c9eabac1316f6033c"
    sha256 x86_64_linux:   "5fe04257ce8fced178d0e8d49cb8a9acf41cb1b95aee30da357d01f6bece6cb3"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  depends_on "libusb"
  depends_on "npth"
  depends_on "pinentry"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    libusb = Formula["libusb"]
    ENV.append "CPPFLAGS", "-I#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"

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
