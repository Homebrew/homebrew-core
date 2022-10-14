class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.8.tar.bz2"
  sha256 "540b7a40e57da261fb10ef521a282e0021532a80fd023e75fb71757e8a4969ed"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ec60821135b7e94e29698cb1899e738f493791737566799eb01db88e57536b27"
    sha256 arm64_big_sur:  "596ca0f1d01560b51164b862dda178a36a94c426b026678fe3a68a5006222758"
    sha256 monterey:       "ad2f839c5d117761debef2be7518ddf24b918fbe252a505d0419862b5e7cd35c"
    sha256 big_sur:        "243073c93c8d72a79ab462a287da6177888624137276e2e524fe7f71dd301555"
    sha256 catalina:       "803c23ba6d6fbde8e77611fe5552e3f6a5e99aa181f85d1813bc81cd4d64f201"
    sha256 x86_64_linux:   "8290c29cd8444ee858e4f5c04c798eaa0d644581d5030aecf1183062f0c6985b"
  end

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

  uses_from_macos "sqlite", since: :catalina

  on_linux do
    depends_on "libidn"
  end

  # Fixes a build failure without ldap.
  # Committed upstream, will be in the next release.
  # https://dev.gnupg.org/T6239
  patch do
    url "https://dev.gnupg.org/rG7011286ce6e1fb56c2989fdafbd11b931c489faa?diff=1"
    sha256 "407011d4ae9799f50008b431df60cd5b781dca0f572e956fd46245aa209af7e8"
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
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry"
    system "make"
    system "make", "check"
    system "make", "install"

    # Configure scdaemon as recommended by upstream developers
    # https://dev.gnupg.org/T5415#145864
    if OS.mac?
      # write to buildpath then install to ensure existing files are not clobbered
      (buildpath/"scdaemon.conf").write <<~EOS
        disable-ccid
      EOS
      pkgetc.install "scdaemon.conf"
    end
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
