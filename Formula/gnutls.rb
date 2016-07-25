class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.14.tar.xz"
  mirror "https://gnupg.org/ftp/gcrypt/gnutls/v3.4/gnutls-3.4.14.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.4/gnutls-3.4.14.tar.xz"
  sha256 "35deddf2779b76ac11057de38bf380b8066c05de21b94263ad5b6dfa75dfbb23"

  bottle do
    cellar :any
    sha256 "8f01f4b29b22aebcca0138d69f354682056478d8e7e55e6d8eb0029098d55692" => :el_capitan
    sha256 "16a1ad8c66569d4c0b254c6844a14429b2bb8b26e764aaf4cc1f62976593f672" => :yosemite
    sha256 "22355e7cd7c02b7852f39f8b653e1e7498d37b9005596748ff49fb9fd7d49f42" => :mavericks
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

    if build.with? "guile"
      args << "--enable-guile"
      args << "--with-guile-site-dir=no"
    end

    system "./configure", *args
    system "make", "install"

    # certtool shadows the OS X certtool utility
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
