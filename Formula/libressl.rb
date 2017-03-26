class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.4.5.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.4.5.tar.gz"
  sha256 "d300c4e358aee951af6dfd1684ef0c034758b47171544230f3ccf6ce24fe4347"

  bottle do
    sha256 "c0f9a4fc4f853b8a98288d4c4151b26d0551a76e87d3fb233213618f23727c8d" => :sierra
    sha256 "6bcd7052d8412883af1d56e2920429d781f38e68df3727bc8eb2bb6bcabc3574" => :el_capitan
    sha256 "525e5a4b9b742c5b5cb037cc3690ab37d104ac82fc990f7f967a390c27b78c2c" => :yosemite
  end

  devel do
    url "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-2.5.2.tar.gz"
    mirror "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.5.2.tar.gz"
    version "2.5.2-beta1"
    sha256 "0ffa7d70809284a4ac96e965918a61c1d7930bca865457a7db0ff0afc8201c82"
  end

  head do
    url "https://github.com/libressl-portable/portable.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only "LibreSSL is not linked to prevent conflict with the system OpenSSL."

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssldir=#{etc}/libressl
      --sysconfdir=#{etc}/libressl
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    keychains = %w[
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    valid_certs = certs.select do |cert|
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $?.success?
    end

    # LibreSSL install a default pem - We prefer to use macOS for consistency.
    rm_f %W[#{etc}/libressl/cert.pem #{etc}/libressl/cert.pem.default]
    (etc/"libressl/cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the SystemRoots
    keychain. To add additional certificates (e.g. the certificates added in
    the System keychain), place .pem files in
      #{etc}/libressl/certs

    and run
      #{opt_bin}/openssl certhash #{etc}/libressl/certs
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise LibreSSL gets moody.
    assert (HOMEBREW_PREFIX/"etc/libressl/openssl.cnf").exist?,
            "LibreSSL requires the .cnf file for some functionality"

    # Check LibreSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
