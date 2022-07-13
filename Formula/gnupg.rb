class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.7.tar.bz2"
  sha256 "ee163a5fb9ec99ffc1b18e65faef8d086800c5713d15a672ab57d3799da83669"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3d5ffaeb2f5601a7ddf78c0a769cf7070d1e25e6f483a5f33b860a4e4be3261c"
    sha256 arm64_big_sur:  "11fbf4cf64905745b3914711302b6cd92a9f0f66b509952bea1f2650abe0db9c"
    sha256 monterey:       "3bcc7890d71594b4a433339cabb021a2411722b32b7b1e1d6638a76b5c2db134"
    sha256 big_sur:        "a57dd6885dc963722958ceb37f62f7a51995213d01a1d11bbac504233dce8908"
    sha256 catalina:       "162e62382693fb09f95fd36c3ae4282f7c1b5544e5cbaa84fbc9ad6c28763d52"
    sha256 x86_64_linux:   "35f12b24951896c4db7926e1574a4f20daf870d7e566130c40024c041690c06b"
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

  # Fixes a regression using Yubikey devices as smart cards.
  # Committed upstream, will be in the next release.
  # https://dev.gnupg.org/T6070
  patch do
    url "https://dev.gnupg.org/rGf34b9147eb3070bce80d53febaa564164cd6c977?diff=1"
    sha256 "0a54359e00ea5e5f0e53220571a4502b28a05cf687cb73b360fb4c777e2f421b"
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
