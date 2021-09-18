class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1l.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1l.tar.gz"
  mirror "https://www.openssl.org/source/old/1.1.1/openssl-1.1.1l.tar.gz"
  sha256 "0b7a3e5e59c34827fe0c3a74b7ec8baef302b98fa80088d7f9153aa16fa76bd1"
  license "OpenSSL"
  version_scheme 1

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(1\.1(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "9acf35f49127e7db9a1190c0c19330cd51f925bc3c482b699aaad802be2fea2b"
    sha256 big_sur:       "ff8b2a965c680b4d9baccd60e799d0989e7dc562d2ba81696a9996bab256a6ad"
    sha256 catalina:      "9c8490c19c5e18a5c9f92c3410b501ad456b348f711f760b2932fd763d0d0c14"
    sha256 mojave:        "e310413752934299a0b8277b5aca3ceeddad0a2cecbcf2a9b81277c2219312b8"
    sha256 x86_64_linux:  "4e8d3bcafe560d3d3ae2e0a29b98fa009101d72c249cd5b99892d706ac23e6dc"
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

  # Fix build on older macOS versions.
  # Remove with the next version.
  patch do
    url "https://github.com/openssl/openssl/commit/96ac8f13f4d0ee96baf5724d9f96c44c34b8606c.patch?full_index=1"
    sha256 "dd5498c0910c0ae91738fe8e796f4deb4767b08217c1a859fe390147f24809c6"
  end

  # Fix build on older macOS versions.
  # Remove with the next version.
  patch do
    url "https://github.com/openssl/openssl/commit/2f3b120401533db82e99ed28de5fc8aab1b76b33.patch?full_index=1"
    sha256 "a66dcd4a3a291858deefaf260ffd8f2f55da953724e7a14db9c4523d8b7ef383"
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
    if OS.linux?
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
    if OS.mac?
      arch_args += %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]
    elsif Hardware::CPU.intel?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
    elsif Hardware::CPU.arm?
      arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
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
    if OS.mac?
      macos_post_install
    else
      linux_post_install
    end
  end

  def macos_post_install
    ohai "Regenerating CA certificate bundle from keychain, this may take a while..."

    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `/usr/bin/security find-certificate -a -p #{keychains.join(" ")}`
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
