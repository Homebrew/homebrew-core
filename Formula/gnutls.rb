class Gnutls < Formula
  desc "GNU Transport Layer Security (TLS) Library"
  homepage "https://gnutls.org/"
  url "https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.14.tar.xz"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.6/gnutls-3.6.14.tar.xz"
  sha256 "5630751adec7025b8ef955af4d141d00d252a985769f51b4059e5affa3d39d63"

  bottle do
    sha256 "40615ea7396142c9337b7f1d8d70d7d1e1d61672cf10a60b09fa22faea6aa06b" => :catalina
    sha256 "d4bcb18b32154069da1878f8499bdf0f391f9b537d6843a445279a6b819fd1b7" => :mojave
    sha256 "7c063a60ae1ab8719bdda9af5d87579f967ea53b158ecbc8f5a8b54a7e9e4f8e" => :high_sierra
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

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{pkgetc}/cert.pem
      --disable-guile
      --disable-heartbeat-support
      --with-p11-kit
    ]

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    system "./configure", *args
    # Adding LDFLAGS= to allow the build on Catalina 10.15.4
    # See https://gitlab.com/gnutls/gnutls/-/issues/966
    system "make", "LDFLAGS=", "install"

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

    pkgetc.mkpath
    (pkgetc/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  test do
    system bin/"gnutls-cli", "--version"
  end
end
