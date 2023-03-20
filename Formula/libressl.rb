class Libressl < Formula
  desc "Version of the SSL/TLS protocol forked from OpenSSL"
  homepage "https://www.libressl.org/"
  # Please ensure when updating version the release is from stable branch.
  url "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.6.2.tar.gz"
  mirror "https://mirrorservice.org/pub/OpenBSD/LibreSSL/libressl-3.6.2.tar.gz"
  sha256 "4be80fff073746cf50b4a8e5babe2795acae98c6b132a9e02519b445dfbfd033"
  license "OpenSSL"

  livecheck do
    url :homepage
    regex(/latest stable release is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_ventura:  "1f9321d2a37b404e8c2f6c519c0d0998337f8256279e37229d4e42637c4e1370"
    sha256 arm64_monterey: "9e4c978d37f29b6e70b0bd077a23b5d8c2f33f4879697f3fcdba90dd70a01955"
    sha256 arm64_big_sur:  "c4d1fb08ea250760dbbc22899e562bd228abc6e40857e815c23c48a1feb46932"
    sha256 ventura:        "f92f70d95e71ebed886f5c5b6b2707ca3c4553b30ddce864b25e19c2c21d852d"
    sha256 monterey:       "fe5360e4e6b6563f141b2301b3c7de84eff72c218b41c33479866c6de4a9df66"
    sha256 big_sur:        "28a9e8b1972ff1edbea8515ac1a1802709fa4015b890b5e69a13d6ad6cbf5c20"
    sha256 x86_64_linux:   "5c9b2db8dd4dd23f921c61c883a2b23d050de82ad1b9a0eaae2d385485b7c609"
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
