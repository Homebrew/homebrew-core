class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.3.3.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.3.3.tar.gz"
  sha256 "a471565b36ccd1a70d0bd7d37c6e95c43a26a62829b487d9d2cdebfe58be3066"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "ee74031a2d77242c7563a3c85db3729b4aaebc9a7013711293977bfc6d475da0"
    sha256 big_sur:       "a87dff5d8d5aed0ca3446c972c98d5d5e1a6c4eea2e728d1d5e53d32578a5f73"
    sha256 catalina:      "091ea83e4b3874ad4c4b5fae7bd12d2cb38649d2992d52c0fd568bf5e1d68c4f"
    sha256 mojave:        "7c77895293158b816cd4a6ff1fbf74ed7c7248c8294bbd836632dd167f3fcd7d"
  end

  head do
    url "https://github.com/libressl-portable/portable.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

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
    on_macos do
      ohai "Regenerating CA certificate bundle from keychain, this may take a while..."

      keychains = %w[
        /Library/Keychains/System.keychain
        /System/Library/Keychains/SystemRootCertificates.keychain
      ]

      certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
      certs = certs_list.scan(
        /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
      )

      # Check that the certificate has not expired
      valid_certs = certs.select do |cert|
        IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout &>/dev/null", "w") do |openssl_io|
          openssl_io.write(cert)
          openssl_io.close_write
        end

        $CHILD_STATUS.success?
      end

      # Check that the certificate is trusted in keychain
      trusted_certs = begin
        tmpfile = Tempfile.new

        valid_certs.select do |cert|
          tmpfile.rewind
          tmpfile.write cert
          tmpfile.truncate cert.size
          tmpfile.flush
          IO.popen("/usr/bin/security verify-cert -l -L -R offline -c #{tmpfile.path} &>/dev/null")

          $CHILD_STATUS.success?
        end
      ensure
        tmpfile&.close!
      end

      # LibreSSL install a default pem - We prefer to use macOS for consistency.
      rm_f %W[#{etc}/libressl/cert.pem #{etc}/libressl/cert.pem.default]
      (etc/"libressl/cert.pem").atomic_write(trusted_certs.join("\n") << "\n")
    end
  end

  def caveats
    <<~EOS
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
    assert_predicate HOMEBREW_PREFIX/"etc/libressl/openssl.cnf", :exist?,
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
