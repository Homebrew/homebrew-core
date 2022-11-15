class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.8.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.7/gnutls-3.7.8.tar.xz"
  sha256 "c58ad39af0670efe6a8aee5e3a8b2331a1200418b64b7c51977fb396d4617114"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_ventura:  "be387b61bde3f06d690ab88984d1d8490163f5341d9190cc7d7e40f7afac73df"
    sha256 arm64_monterey: "2de64828679245123f641ecdc5b166b444f24586184d0d5717b4ac446406009f"
    sha256 arm64_big_sur:  "4792aaa463b7f12a7ea0ec855f47a37970797b578083a717356a16cd4a4fdad6"
    sha256 ventura:        "02b9851e94840641c2016e4c04150bee1b6f728163e963197f53138ef185233f"
    sha256 monterey:       "6bd29803c8373834e2a202a1998fe8b278b65a0dcd828e9b05d76b9be1d5a623"
    sha256 big_sur:        "838253c281b1e3b9d6381ab37ed31721c77a31efd6afcff7c778bc28ce653f9f"
    sha256 catalina:       "90fec765342bfc3776982274521d27841557555a7b4eec3dc9740344b988366e"
    sha256 x86_64_linux:   "c35d31c338bae2286575eee494fc6792b2a3cb7835d2ce3cc984ce9df52f66ed"
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "guile"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "unbound"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --with-guile-site-dir=#{share}/guile/site/3.0
      --with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache
      --with-guile-extension-dir=#{lib}/guile/3.0/extensions
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

    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch lib/"guile/3.0/site-ccache/gnutls.go"
  end

  def caveats
    <<~EOS
      If you are going to use the Guile bindings you will need to add the following
      to your .bashrc or equivalent in order for Guile to find the TLS certificates
      database:
        export GUILE_TLS_CERTIFICATE_DIRECTORY=#{pkgetc}/
    EOS
  end

  test do
    system bin/"gnutls-cli", "--version"

    gnutls = testpath/"gnutls.scm"
    gnutls.write <<~EOS
      (use-modules (gnutls))
      (gnutls-version)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gnutls
  end
end
