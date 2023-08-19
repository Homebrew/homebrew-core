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
    sha256 arm64_ventura:  "e3c3e0156bee79b8af745e9d4587ccca48afe3a50a25071bfb185b3cfe41a215"
    sha256 arm64_monterey: "cdc74eb7c4741a37f941c079e8b9ffccf5eba5bec0bef0a8ccd4015ffa47a6d6"
    sha256 arm64_big_sur:  "3c9025adfc14b84487257f7947e0dbe9566713ed885076f21d5d5215c23add87"
    sha256 ventura:        "ca7d2a952ba2da27cc1a8b2441036ec3da0ec2957c97a97ab309390f147e335e"
    sha256 monterey:       "dfa28ed4633b865f74e66bc1ceb43c3ab6f372b93e3325323de7a3d00d334c6c"
    sha256 big_sur:        "18aeb28de21fa30a45feb1de8398f02a87010ee9399c58d15e8b75fe786e81ed"
    sha256 x86_64_linux:   "e31730b3d965f48969ce3bcc1a8710aa2324ae8d29487f03e75bef68adbe8ab3"
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
