class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.13.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.5/gnutls-3.5.13.tar.xz"
  sha256 "79f5480ad198dad5bc78e075f4a40c4a315a1b2072666919d2d05a08aec13096"

  bottle do
    sha256 "bee5a457b6bf7cc760c760fbe707606c2036a2277df231b7e96b8ef7a88a8d24" => :sierra
    sha256 "52cb55c0380ff6e13fade4988b2ddce2a3b2e7fa181577a193860bcb88a49b0f" => :el_capitan
    sha256 "62a70510d0b4cb2f1427832f7be7241aaa07db67d4f7695a9568eb2202791734" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
  depends_on "libunistring"
  depends_on "p11-kit" => :recommended
  depends_on "guile" => :optional
  depends_on "unbound" => :optional

  def install
    # Fix "dyld: lazy symbol binding failed: Symbol not found: _getentropy"
    # Reported 18 Oct 2016 https://gitlab.com/gnutls/gnutls/issues/142
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "getentropy(0, 0);", "undefinedgibberish(0, 0);"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
    ]

    if build.with? "p11-kit"
      args << "--with-p11-kit"
    else
      args << "--without-p11-kit"
    end

    if build.with? "guile"
      args << "--enable-guile" << "--with-guile-site-dir"
    else
      args << "--disable-guile"
    end

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

      $?.success?
    end

    openssldir = etc/"openssl"
    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  test do
    system bin/"gnutls-cli", "--version"
  end
end
