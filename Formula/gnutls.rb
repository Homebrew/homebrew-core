class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.17.tar.xz"
  mirror "https://gnupg.org/ftp/gcrypt/gnutls/v3.4/gnutls-3.4.17.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.4/gnutls-3.4.17.tar.xz"
  sha256 "9b50e8a670d5e950425d96935c7ddd415eb6f8079615a36df425f09a3143172e"
  revision 1

  bottle do
    sha256 "613d98861f14e5a880d8a9567b42d680a118f5ee38946a0cf70c6952293a9dd2" => :sierra
    sha256 "279c874f80267ef7af89f36220c9bf3cae148be36d2ac30a615b862b00b40cd0" => :el_capitan
    sha256 "f08c75ac18752eb56cccb756b33727668900fe2ff63b039fcbebc9c504052460" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
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
