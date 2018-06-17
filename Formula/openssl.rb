# This formula tracks 1.0.2 branch of OpenSSL, not the 1.1.0 branch. Due to
# significant breaking API changes in 1.1.0 other formulae will be migrated
# across slowly, so core will ship `openssl` & `openssl@1.1` for foreseeable.
class Openssl < Formula
  desc "SSL/TLS cryptography library"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.0.2o.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.0.2o.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.0.2o.tar.gz"
  mirror "http://artfiles.org/openssl.org/source/openssl-1.0.2o.tar.gz"
  sha256 "ec3f5c9714ba0fd45cb4e087301eb1336c317e0d20b575a125050470e8089e4d"
  revision 2

  bottle do
    sha256 "57d848340949e76f8ff3a59c3db92b462be55f2792d9d3a5becad54512ebf4fd" => :high_sierra
    sha256 "a59327ee00013f2062304f22a4daabf3371ca44926f31fcf500b339b4aa8e146" => :sierra
    sha256 "dba683c9d3091217b0d33a9f44f81e0b7b4d0e5205133f3076bb1469107a1001" => :el_capitan
  end

  keg_only :provided_by_macos,
    "Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries"

  option "without-test", "Skip build-time tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "makedepend" => :build

  def arch_args
    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386 => %w[darwin-i386-cc],
    }
  end

  def configure_args; %W[
    --prefix=#{prefix}
    --openssldir=#{openssldir}
    no-ssl2
    no-ssl3
    no-zlib
    shared
    enable-cms
  ]
  end

  def install
    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete("PERL")
    ENV.delete("PERL5LIB")

    if MacOS.prefer_64_bit?
      arch = Hardware::CPU.arch_64_bit
    else
      arch = Hardware::CPU.arch_32_bit
    end

    ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args[arch])
    system "make", "depend"
    system "make"
    system "make", "test" if build.with?("test")

    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl"
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

      $CHILD_STATUS.success?
    end

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<~EOS
    A CA file has been bootstrapped using certificates from the SystemRoots
    keychain. To add additional certificates (e.g. the certificates added in
    the System keychain), place .pem files in
      #{openssldir}/certs

    and run
      #{opt_bin}/c_rehash
  EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate HOMEBREW_PREFIX/"etc/openssl/openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
