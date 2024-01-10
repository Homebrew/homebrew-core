class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.2.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.8/gnutls-3.8.2.tar.xz"
  sha256 "e765e5016ffa9b9dd243e363a0460d577074444ee2491267db2e96c9c2adef77"
  license all_of: ["LGPL-2.1-or-later", "GPL-3.0-only"]

  livecheck do
    url "https://www.gnutls.org/news.html"
    regex(/>\s*GnuTLS\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  bottle do
    sha256 arm64_sonoma:   "3e685ee9d72100553637eb11933f0b5d19497ced063cf80cfa490a6b74da6009"
    sha256 arm64_ventura:  "48cbe35994d3baa0f4fcaf1567c8143b63800c9f913c673d9ececf9a0be676f7"
    sha256 arm64_monterey: "dfcc31686500bfe4b91038963b6e4a86caf023ae08f4300d09453434494fddbe"
    sha256 sonoma:         "8b242a4f13fccec63998dc480d3ba6b5a18138e954ba0923dfcffaed4973b9b9"
    sha256 ventura:        "d01d7954a2d08a809491d36d21b99e31aebfa2278853a99f055b5b83d91628bb"
    sha256 monterey:       "e261b16cd10d7fe654a10862efd9a2aaf28eced0142201e19cd53734654cdc77"
    sha256 x86_64_linux:   "3827cd32aa6a9cd29a91bf788afa51ac5a88bf87f93355fd0f260a17480ab176"
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "gmp"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"

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
