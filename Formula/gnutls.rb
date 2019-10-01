class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.9.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.6/gnutls-3.6.9.tar.xz"
  sha256 "4331fca55817ecdd74450b908a6c29b4f05bb24dd13144c6284aa34d872e1fcb"

  bottle do
    sha256 "919a4cbaf5a160dbbe94811b6cc399b91986e4d13ce69d107b812265a0156dff" => :mojave
    sha256 "6f8bc3a47210b4c86fbbca4a445c311786e7fb31e4cd5c81d9a6654927016b1a" => :high_sierra
    sha256 "d13c3930d861d58d936c9c5e0d6d99dac16e23bc2dd125cf0e092aa683332754" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "libidn2"
  depends_on "libtasn1"
  depends_on "libunistring"
  depends_on "nettle"
  depends_on "p11-kit"
  depends_on "unbound"

  # Patch for build error on Sierra:
  #   Undefined symbols for architecture x86_64:
  #     "___get_cpuid_count", referenced from:
  #     _register_x86_crypto in libaccelerated.a(x86-common.o)
  #
  # This patch has been merged upstream and this issue should be fixed in the 3.6.10 release.
  patch do
    url "https://gitlab.com/gnutls/gnutls/commit/ef80617d1e17e0878a909baad62a75ba265c0e00.diff"
    sha256 "aa8b92375e3bced3f81fe8a820d5dabaa68cac332aed097d45be01080f517460"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-guile
      --disable-heartbeat-support
      --with-p11-kit
    ]

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    system "./configure", *args
    system "make", "install"

    # certtool shadows the macOS certtool utility
    mv bin/"certtool", bin/"gnutls-certtool"
    mv man1/"certtool.1", man1/"gnutls-certtool.1"
  end

  def post_install
    keychains = %w[
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(/-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m)

    valid_certs = certs.select do |cert|
      IO.popen("openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $CHILD_STATUS.success?
    end

    openssldir = etc/"openssl"
    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  test do
    system bin/"gnutls-cli", "--version"
  end
end
