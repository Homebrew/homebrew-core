class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.7.2.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.7.2.tar.gz"
  sha256 "b06aa538fefc9c6b33c4db4931a09a5f52d9d2357219afcbff7d93fe12ebf6f7"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_ventura:  "cef0f70deeefe8cd1dd62d17f946f01e7c305935aa33b97b016023b8bf3b015b"
    sha256 arm64_monterey: "b66002cbc7d9b5caf3766d11296b328bdfc97721b15079e4882381ff24014282"
    sha256 arm64_big_sur:  "ed7802d8997110b973962c84b97364d2db19dd86182aab3675adb1e9cb5fe343"
    sha256 ventura:        "03150465bd4a1639951e4195bbdc4509807833b05a6a9cbaa87d225004a6640e"
    sha256 monterey:       "32e89ea438e71bee8a583209d4374ab71fb67b1abc2bcb45f692cd45c5415af0"
    sha256 big_sur:        "95be86d699e5ca7e62cfcba6dd0626ad09e83e5352debe3fd0d9ef87d4303919"
    sha256 x86_64_linux:   "11f3460b11c6a4e556638fe397d59fd14d742b80858ea7c8db43220a6bc716a7"
  end

  head do
    url "https://github.com/libressl-portable/portable.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  on_linux do
    keg_only "it conflicts with OpenSSL formula"
  end

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
    system "make", "install"
  end

  def post_install
    if OS.mac?
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
