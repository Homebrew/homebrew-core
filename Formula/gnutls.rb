class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.1.tar.xz"
  sha256 "ba8b9e15ae20aba88f44661978f5b5863494316fe7e722ede9d069fe6294829c"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_ventura:  "a10227b5f3b46064fb325eb21d5103b6fad145dbbb87abd4f8ff8d76270ea32a"
    sha256 arm64_monterey: "d375f9982faad9b6664508624629c9018ecf807d34c38bb91f875557cc9aa0cf"
    sha256 arm64_big_sur:  "d21c45d81baaf4ea81a6ff134bad1df8575e5e7e50186e24d74d42402220a2d2"
    sha256 ventura:        "a41072e29a3fe9bdf8408946b7ad308b1d504e87c79d5bb39dd57172354d4e73"
    sha256 monterey:       "75da330e4d73ade890aa0c998443319d07d4d63089bfd6c16bf7d87ba756bff5"
    sha256 big_sur:        "d1cddbab50cd28e1e84b57bb3c08e76c204626894bebf044c80fdb3c44d8a577"
    sha256 x86_64_linux:   "7a131f11110a752a7326a0b1c57dff58c7fc4eea5f2a1e4ae7de781d71532883"
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
    system bin/"gnutls-cli", "--version"
    assert_match "expired certificate", shell_output("#{bin}/gnutls-cli expired.badssl.com", 1)
  end
end
