class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1k.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1k.tar.gz"
  mirror "https://www.openssl.org/source/old/1.1.1/openssl-1.1.1k.tar.gz"
  sha256 "892a0875b9872acd04a9fde79b1f943075d5ea162415de3047c327df33fbaee5"
  license "OpenSSL"
  version_scheme 1

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(1\.1(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "0a75e0f116c0653bc7a2b422e5dc500e7e51557303aa4fca9c1a28786189c1da"
    sha256 big_sur:       "17d94c51ddfa8364baed5f3a754063e1ca75f807194f68d0b976619cf4e69c1a"
    sha256 catalina:      "cb610ecdda346011031b890d7b7c6e1942d7fc08cf083b74f148ec7ffed8c7e1"
    sha256 mojave:        "7928c80c309c6ece50b1c0d968a1e54011088cc896d26aa511249978a246bd50"
  end

  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  on_linux do
    resource "cacert" do
      # homepage "http://curl.haxx.se/docs/caextract.html"
      url "https://curl.haxx.se/ca/cacert-2020-01-01.pem"
      mirror "https://gist.githubusercontent.com/dawidd6/16d94180a019f31fd31bc679365387bc/raw/ef02c78b9d6427585d756528964d18a2b9e318f7/cacert-2020-01-01.pem"
      sha256 "adf770dfd574a0d6026bfaa270cb6879b063957177a991d453ff1d302c02081f"
    end

    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz"
      sha256 "0fd90d4efea82d6e262e6933759e85d27cbcfa4091b14bf4042ae20bab528e53"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302175.tar.gz"
      sha256 "c8c8f5c51ad6d7a858c3b61b8b658d8e789d3da5d300065df0633875b0075e49"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.48.tar.gz"
      sha256 "94e64a630fc37e80c0ca02480dccfa5f2f4ca4b0dd4eeecc1d65acd321c68289"
    end
  end

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      no-ssl3
      no-ssl3-method
      no-zlib
    ]
    on_linux do
      args += (ENV.cflags || "").split
      args += (ENV.cppflags || "").split
      args += (ENV.ldflags || "").split
      args << "enable-md2"
    end
    args
  end

  def install
    on_linux do
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      %w[ExtUtils::MakeMaker Test::Harness Test::More].each do |r|
        resource(r).stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
          system "make", "install"
        end
      end
    end

    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = Formula["perl"].opt_bin/"perl" if which("perl") == Formula["perl"].opt_bin/"perl"

    arch_args = []
    on_macos do
      arch_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    end
    on_linux do
      if Hardware::CPU.intel?
        arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
      elsif Hardware::CPU.arm?
        arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
      end
    end

    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def openssldir
    etc/"openssl@1.1"
  end

  def post_install
    on_macos(&method(:macos_post_install))
    on_linux(&method(:linux_post_install))
  end

  def macos_post_install
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

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(trusted_certs.join("\n") << "\n")
  end

  def linux_post_install
    # Download and install cacert.pem from curl.haxx.se
    cacert = resource("cacert")
    cacert.fetch
    rm_f openssldir/"cert.pem"
    filename = Pathname.new(cacert.url).basename
    openssldir.install cacert.files(filename => "cert.pem")
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
