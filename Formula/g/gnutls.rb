class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.3.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.3.tar.xz"
  sha256 "f74fc5954b27d4ec6dfbb11dea987888b5b124289a3703afcada0ee520f4173e"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_sonoma:   "e56a8040de546196d50156e40673c1f932820adfd7b87ff05d9fb7d8d1729c0d"
    sha256 arm64_ventura:  "ececffc311fa3ec8f0d4576cdcc6f31dc1152cb365a773d537c64d789e9251dc"
    sha256 arm64_monterey: "2773884a8ac832948974bd13316e2b79cbf6c37becdab9b5762425bc5826e998"
    sha256 sonoma:         "9beb8badafa9dc4ecb08e797340b45b518931cf3b641aa4ffa00bf6f89787f81"
    sha256 ventura:        "38c8435f33f0296eb5263b8e8a2f93eea22f0ff349d3d582f628ff63d78ae3af"
    sha256 monterey:       "64fa0e2d07ea245b18f1e9179ca6213afe7495f3f715abe34de3018080d41906"
    sha256 x86_64_linux:   "3cf526c00c2078d354a33947e9910e36462fc0f77c624e871fc0ca2aa873b177"
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
