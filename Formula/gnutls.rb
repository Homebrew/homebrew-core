class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-3.5.11.tar.xz"
  mirror "https://gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.11.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.5/gnutls-3.5.11.tar.xz"
  sha256 "51765cc5579e250da77fbd7871507c517d01b15353cc40af7b67e9ec7b6fe28f"

  bottle do
    sha256 "06ee8b8fa03da686bb41570474dd4477870b77557da52c3e73045e3e6e6c089f" => :sierra
    sha256 "cce1fd251cffc0f5d4dfcc11dbb8c77a5be4a38cc4184e3b79e7c25fb6643db8" => :el_capitan
    sha256 "7ab7ffac6bdc998fe8f9e3fd1373b9b587562116a49c6467bc97f36d40a31803" => :yosemite
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
