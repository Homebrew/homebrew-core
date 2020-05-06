class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1g.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.1.1g.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1g.tar.gz"
  sha256 "ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46"
  version_scheme 1

  bottle do
    sha256 "1926679569c6af5337de812d86f4dad2b21ff883ad3a5d2cd9e8836ac5ac7ffe" => :catalina
    sha256 "5c9d113393ff3efc95e5509175305fc9304fba35390a61915ed2864941c423f2" => :mojave
    sha256 "eebad96faa46489dc8bf8502b16ec0192f5ff9d803794c9744ad50352bfca0f7" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      no-ssl3
      no-ssl3-method
      no-zlib
    ]
  end

  def install
    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = Formula["perl"].opt_bin/"perl" if which("perl") == Formula["perl"].opt_bin/"perl"

    arch_args = %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128]

    ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "test"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl@1.1"
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
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout >/dev/null", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $CHILD_STATUS.success?
    end

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n") << "\n")
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate pkgetc/"openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
