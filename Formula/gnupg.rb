class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.3.3.tar.bz2"
  sha256 "5789b86da6a1a6752efb38598f16a77af51170a8494039c3842b085032e8e937"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e0c876562d5c9d078fe3b08db9bf4da15938d0b7827bbf8b7e3e873abc127d77"
    sha256 arm64_big_sur:  "c4898e583948756ba9f0ff56457b6f1e33cfec995dfbbbee1daf9850b625e62c"
    sha256 monterey:       "345f854a5b919a0b5c8949d00a266fc581c371ebe2657af13d73525a550b732e"
    sha256 big_sur:        "17d29fc172874c22274cbb9b3d5dedfced573d1bfa5638409a2c314cc57a8901"
    sha256 catalina:       "556b4a23ba2c52e591daa1f54cee6d28e8efcb4d3d0a5a1d9b0197baf4cb0df8"
    sha256 mojave:         "c810ba1b9c921b06387e1de4155b34b0e8c036cf2016a054a9e19b4fd0614fed"
    sha256 x86_64_linux:   "9c0d1bcb1fb214a7fde6ab0a9d1ca082466e347834e108c397831512214f6561"
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

  def install
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
