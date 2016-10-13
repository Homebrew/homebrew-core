class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.15.tar.xz"
  mirror "https://gnupg.org/ftp/gcrypt/gnutls/v3.4/gnutls-3.4.15.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.4/gnutls-3.4.15.tar.xz"
  sha256 "eb2a013905f5f2a0cbf7bcc1d20c85a50065063ee87bd33b496c4e19815e3498"

  bottle do
    cellar :any
    sha256 "b51f3a06fe00e27074aad8c65ecd86fe0fcb5df8d9b4379c9e452a812207b898" => :sierra
    sha256 "2a18ae1b67e4d55ec3d749a06ac0471456daff44ac52156e1824d32d0d0675b2" => :el_capitan
    sha256 "c7f30aa4ea4d054e0d788e9948fcd6ff03b353525319ff80de8063659c40ea65" => :yosemite
    sha256 "a30400a5dd19c4830697403b0d297c8ffd10a57b122b02eb06213b1066373897" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
  depends_on "guile" => :optional
  depends_on "unbound" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
      --without-p11-kit
    ]
    args << "--enable-guile" << "--with-guile-site-dir" if build.with? "guile"

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
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m
    )

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
