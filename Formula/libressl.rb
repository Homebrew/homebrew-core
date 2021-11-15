class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.4.1.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.4.1.tar.gz"
  sha256 "107ceae6ca800e81cb563584c16afa36d6c7138fade94a2b3e9da65456f7c61c"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_monterey: "b3c161f83a811ebc2d949ebc67d0cc4bf6f93cd89361ac1aeec47ef06dae8532"
    sha256 arm64_big_sur:  "41f4e9f8cdf03ae83c8fdff6867bbd36127c389004fb89a410630c74dac315f9"
    sha256 monterey:       "806d3b611485fab207bbeb7126643240adb8582f985f3e6546815953eb968611"
    sha256 big_sur:        "e3c8dae6f39e42a652df8e66f02a0e581e31697fbfdc7465813306c48f6931d5"
    sha256 catalina:       "4490e48658eab39495b885811d1762666d6c837013c3f990cda1eebf8bb400fc"
    sha256 mojave:         "7ce48d13e2e1cae8569598a6d456c8843263547fc1753f2a5869e61fd50c6fa6"
    sha256 x86_64_linux:   "aa3d726e0bf1159fa3ad3cb1657525e1f37e6fcfafb79ff9be07ccd34d559035"
  end

  head do
    url "https://github.com/libressl-portable/portable.git"

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
    system "make", "check"
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
