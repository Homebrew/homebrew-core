class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1h.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.1.1h.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1h.tar.gz"
  sha256 "5c9ca8774bd7b03e5784f26ae9e9e6d749c9da2438545077e6b3d755a06595d9"
  license "OpenSSL"
  version_scheme 1

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(1\.1(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 "81fe98e819f1d3554d98cbf615c848cc1837c65b6026cb561b0d58531b0ab65e" => :big_sur
    sha256 "4e5357c0cfd55cfa4ef0b632c6fc9f49d39337dd070dc12d3c862e28bd28f079" => :catalina
    sha256 "d4ef27b41d0596d20b79a43a43554d4ea1395f0ef9affdcf0ce74114a00e2572" => :mojave
    sha256 "face6b0b99e7d628232e379f02aeb9d0eb7d1b5efba77561e0fd9edba130393d" => :high_sierra
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

  # Add darwin64-arm64-cc build target.
  # See: https://github.com/openssl/openssl/pull/12369
  patch do
    url "https://github.com/stuartcarnie/openssl/commit/4907cf01f63cc966a40d67eb2e030c4d8eb1d528.patch?full_index=1"
    sha256 "2c0af13764c9d52bb9e04687d430d5e2682bb877b790f089c348c8de0434ad00"
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

    ENV.deparallelize
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
