class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.4.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.4.tar.xz"
  sha256 "2bea4e154794f3f00180fa2a5c51fe8b005ac7a31cd58bd44cdfa7f36ebc3a9b"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_sequoia:  "e927eab61e775a8b65079c2163fb29b9f03c90caf68cc13788dfea249ed6201e"
    sha256 arm64_sonoma:   "46373a7206cc70289bfef2081508c62cc74a2589060b21ce26c44c4c86fbda41"
    sha256 arm64_ventura:  "7b18d9403f8cc6a5e2e3fd427a07e32ccb1d7969715fbf5b72cfb4b5a01d8a3c"
    sha256 arm64_monterey: "2a6bb19c341be5dcc2e351e68380b05f246407bd57b2dc7e94743d14e473cde8"
    sha256 sonoma:         "7136ceb68e1bf94ad28db2990cc10da909b742390be65963b78e8b115f97b51d"
    sha256 ventura:        "08b8fc7ded2a17510ab505965c754bccf3cf21ae690d76af744f96d800223de2"
    sha256 monterey:       "80f7875ba4d2409f85851a3c61bf8c178415e863528357bc587578e8d0536c10"
    sha256 x86_64_linux:   "9bedb5b302e02e32c64bf75c488216dd644bc205d9e99d2b26edfdf7f3d81b93"
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

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      --disable-silent-rules
      --disable-static
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --disable-heartbeat-support
      --with-p11-kit
    ]

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    rm(pkgetc/"cert.pem") if (pkgetc/"cert.pem").exist?
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
