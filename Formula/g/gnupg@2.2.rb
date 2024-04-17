class GnupgAT22 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.43.tar.bz2"
  sha256 "a3b34c40f455d93054d33cf4cf2a8ce41149d499eca2fbb759619de04822d453"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(2\.2(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "40c89c2b75dfc5664f23467620eca04ce2a521df71c3c27e8d8458fd83e7945c"
    sha256 arm64_ventura:  "d07caa67766ee2a38396ff98c3a40f8c1706ace3bd74a952fe53e813c3ab002b"
    sha256 arm64_monterey: "0dde167623f5f5b5b665d9d6bb0dcc17d8c6b323fc93f7dc7c05b262e348e239"
    sha256 sonoma:         "78b9e6163f29dc21ee8bb2a80949062f85b46a46e6ba930a821ad26752596ca2"
    sha256 ventura:        "34835eb5e3d0fab2ad90b09d493ade94c95a74ea2a4d7f1d80541caa150f367e"
    sha256 monterey:       "ef89f38a4413e5b5f0df140c7a555064b861a31dcd4b18ad040a1fb2bdfba6a1"
    sha256 x86_64_linux:   "9079309d3412821c6edb7710a9cbfce8dfc6b14792bd60a1a2aaff77940c1aa9"
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
