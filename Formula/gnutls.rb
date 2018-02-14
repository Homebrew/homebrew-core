class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.17.tar.xz"
  sha256 "86b142afef587c118d63f72ccf307f3321dbc40357aae528202b65d913d20919"

  bottle do
    sha256 "b8695efb702342ec890527c070337794c7dd3f9a2226d3a5f39eff02c76501f6" => :high_sierra
    sha256 "108306d125b36fd5dce4a7440cd1c74fd22e5c9997304d4b4123fcef02f6b5ff" => :sierra
    sha256 "7f3cc230e0ec1c26729130ea40aa3f9d3d6843cea2cac744eb39e65b819928f9" => :el_capitan
  end

  devel do
    url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.0.tar.xz"
    mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.6/gnutls-3.6.0.tar.xz"
    sha256 "2ab9e3c0131fcd9142382f37ba9c6d20022b76cba83560cbcaa8e4002d71fb72"
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
