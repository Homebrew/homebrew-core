class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-3.1.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.1.0.tar.gz"
  sha256 "aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4"
  license "Apache-2.0"

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1dd3c96c86bcd743dc8a7e1b0d18c7d76eb4d733ce7768e3931ad027f7b1d1fd"
    sha256 arm64_monterey: "cb8b2e4bbf311516addc310c067e9655aca5e4f697b134580d3147624616aa5f"
    sha256 arm64_big_sur:  "b994e140d306335dc48a85bb41aea685e0e41dd67978027261acd6c0b6aaa532"
    sha256 ventura:        "64e237e99be9d8ee4ddfd3813384ace1920f28ed1f74fac2730908839aaddc40"
    sha256 monterey:       "a6327ea42283c5fdc582b431da337a6aa371ed9ca019e1ca9d8a40e273535a0d"
    sha256 big_sur:        "2f678f6bb7b0ca91b17aada633fe617dd0f2b05eafd1c9cc2497535a4a8f3f86"
    sha256 x86_64_linux:   "20295ac304dcaf92f82260fa8fcb2e28a85a2860e571e514f17e7411b45ea1aa"
  end

  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  depends_on "ca-certificates"

  on_linux do
    keg_only "it conflicts with the `openssl@1.1` formula"

    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz"
      sha256 "0fd90d4efea82d6e262e6933759e85d27cbcfa4091b14bf4042ae20bab528e53"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302186.tar.gz"
      sha256 "2895c8da7c3fe632e5714c7cc548705202cdbf3afcbc0e929bc5e6a5172265d4"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.62.tar.gz"
      sha256 "5022ad857fd76bd3f6b16af099fe2324639d9932e08f21e891fb313d9cae1705"
    end
  end

  # fix build on macOS pre-10.14; remove in 3.1.1; see openssl/openssl#19361
  patch do
    url "https://github.com/openssl/openssl/commit/96f1dbea67247b79b1e7b3f83f2964dc626d86ce.patch?full_index=1"
    sha256 "95d662ce38c84bb7e4ca1f78420815360f6254e95854915b067739db23e4df20"
  end
  patch do
    url "https://github.com/openssl/openssl/commit/d4765408c705f704f7cf33bd32bfb713061954a7.patch?full_index=1"
    sha256 "fe79b4bfe1daf2995b49b3a57bc1d4f07d615871300424ce9091096e3bb1501b"
  end
  patch do
    url "https://github.com/openssl/openssl/commit/110dac578358014c29b86cf18d9a4bfe5561e3bc.patch?full_index=1"
    sha256 "27da17844cb47fbeaac237ad8082d2e2c8ace523fd93b07a5a7fde6d6ad05c62"
  end

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      --libdir=#{lib}
      no-ssl3
      no-ssl3-method
      no-zlib
    ]
    on_linux do
      args += (ENV.cflags || "").split
      args += (ENV.cppflags || "").split
      args += (ENV.ldflags || "").split
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

    openssldir.mkpath
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"
  end

  def openssldir
    etc/"openssl@3"
  end

  def post_install
    rm_f openssldir/"cert.pem"
    openssldir.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
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
