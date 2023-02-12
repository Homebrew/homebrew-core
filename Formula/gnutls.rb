class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.0.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.0.tar.xz"
  sha256 "0ea0d11a1660a1e63f960f157b197abe6d0c8cb3255be24e1fb3815930b9bdc5"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_ventura:  "426984f462990e271967d344024ddd6cf5fd1a05c31f8e107f957d001f96cf33"
    sha256 arm64_monterey: "8b3e1d40d8e47e87210227552d007cc49e9f1b8a7880c830f623bdbd0491a35e"
    sha256 arm64_big_sur:  "a80a61fca20831652d166b614a4ec8fa6ba98d37d46c116a1bb1aa00c5b7dbce"
    sha256 ventura:        "53d488f2329fccccab5a1184c116f2bdeff137cfd3c400ebb02ea6c5b9d12e25"
    sha256 monterey:       "655e8c46cd3d815b74975797cfc8fcee75b47bafdf437f981788203bc271b2c8"
    sha256 big_sur:        "8bfc8baea81e2bfdfd823beec39f4d1eed709b1becb1debb793850d323a2d66e"
    sha256 x86_64_linux:   "9fd1beca90332d31e86d5e36f4a19a522b632f4931d075c9af516d7ac81d4485"
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "unbound"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --disable-heartbeat-support
      --with-p11-kit
    ]

    system "./configure", *args
    system "make", "install"

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    rm_f pkgetc/"cert.pem"
    pkgetc.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      Guile bindings are now in the `guile-gnutls` formula.
    EOS
  end

  test do
    # TODO: Ship a better test.
    system bin/"gnutls-cli", "--version"
  end
end
