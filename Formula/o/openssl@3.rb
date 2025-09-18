class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl-library.org"
  url "https://github.com/openssl/openssl/releases/download/openssl-3.5.2/openssl-3.5.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/openssl-3.5.2.tar.gz"
  sha256 "c53a47e5e441c930c3928cf7bf6fb00e5d129b630e0aa873b08258656e7345ec"
  license "Apache-2.0"

  livecheck do
    url "https://openssl-library.org/source/"
    regex(/href=.*?openssl[._-]v?(3(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7c99266a207a94a8e478ae5c23332683c3d70e32edca3a4f2441a4c968401511"
    sha256 arm64_sequoia: "4066d7983ad535f0e460fc340f343f9de933073882470d5ea968b18698b2777c"
    sha256 arm64_sonoma:  "c52ef84abb4c58734add7475eafefd91890f7b56f5d4e2271a1ad6ddc40f5ef5"
    sha256 arm64_ventura: "13545dea2fcfac0542556f969011892b2e0001b5ef0b71a787ca4ad714567ef5"
    sha256 tahoe:         "126f37678bbdca3e23357b69af1b3f24d6d17628ffed272ea0a052e62e741c0b"
    sha256 sequoia:       "13d2f6fc2b05e14af0351797e8605bd8aee8888272d8205632f6c981be7e2518"
    sha256 sonoma:        "dcbc84c30251575424915590a347d12f89088e055a76da319422f887d9e71faf"
    sha256 ventura:       "b51da4aaa601358273a5161c8aea4b19998ac1c48224a4b067c4c3e5475f9482"
    sha256 arm64_linux:   "d7f7244863cff02f6e0fc002d50dc7031b36186c036e7d42233ab87dff8ce018"
    sha256 x86_64_linux:  "df175dfc2681763571f5f680110f82343336171eca4220c8db401341b39dc87d"
  end

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.52.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.52.tar.gz"
      sha256 "8fe65cfc0261ed3c8a4395f0524286f5719669fe305f9b03b16cf3684d62cd70"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302214.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302214.tar.gz"
      sha256 "6077ecc35f37b11b3b75df2d0ba1b9ca541f1dc24b2be8e15b6e91f78e2e03fc"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.76.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.76.tar.gz"
      sha256 "30bcfd75fec4d512e9081c792f7cb590009d9de2fe285ffa8eec1be35a5ae7ca"
    end
  end

  link_overwrite "bin/c_rehash", "bin/openssl", "include/openssl/*"
  link_overwrite "lib/libcrypto*", "lib/libssl*"
  link_overwrite "lib/pkgconfig/libcrypto.pc", "lib/pkgconfig/libssl.pc", "lib/pkgconfig/openssl.pc"
  link_overwrite "share/doc/openssl/*", "share/man/man*/*ssl"

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      --libdir=lib
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
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"
      ENV.prepend_path "PATH", buildpath/"bin"

      %w[ExtUtils::MakeMaker Test::Harness Test::More].each do |r|
        resource(r).stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
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
    # AF_ALG support isn't always enabled (e.g. some containers), which breaks the tests.
    # AF_ALG is a kernel feature and failures are unlikely to be issues with the formula.
    system "make", "HARNESS_JOBS=#{ENV.make_jobs}", "test", "TESTS=-test_afalg"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| openssldir/subdir/".keepme" }
  end

  def openssldir
    etc/"openssl@3"
  end

  def post_install
    rm(openssldir/"cert.pem") if (openssldir/"cert.pem").exist?
    openssldir.install_symlink Formula["ca-certificates"].pkgetc/"cert.pem"
  end

  def caveats
    <<~EOS
      To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_path_exists pkgetc/"openssl.cnf", "OpenSSL requires the .cnf file for some functionality"
    assert_path_exists openssldir/"certs", "OpenSSL throws confusing errors when this directory is missing"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end

    # Invalid cert from superfish.badssl.com
    bad_cert = <<~PEM
      -----BEGIN CERTIFICATE-----
      MIIC9TCCAl6gAwIBAgIJAK5EmlK7Klu5MA0GCSqGSIb3DQEBCwUAMFsxGDAWBgNV
      BAoTD1N1cGVyZmlzaCwgSW5jLjELMAkGA1UEBxMCU0YxCzAJBgNVBAgTAkNBMQsw
      CQYDVQQGEwJVUzEYMBYGA1UEAxMPU3VwZXJmaXNoLCBJbmMuMB4XDTE4MDUxNjE3
      MTUyM1oXDTIwMDUxNTE3MTUyM1owajELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNh
      bGlmb3JuaWExFjAUBgNVBAcMDVNhbiBGcmFuY2lzY28xDzANBgNVBAoMBkJhZFNT
      TDEdMBsGA1UEAwwUc3VwZXJmaXNoLmJhZHNzbC5jb20wggEiMA0GCSqGSIb3DQEB
      AQUAA4IBDwAwggEKAoIBAQDCBOz4jO4EwrPYUNVwWMyTGOtcqGhJsCK1+ZWesSss
      dj5swEtgTEzqsrTAD4C2sPlyyYYC+VxBXRMrf3HES7zplC5QN6ZnHGGM9kFCxUbT
      Focnn3TrCp0RUiYhc2yETHlV5NFr6AY9SBVSrbMo26r/bv9glUp3aznxJNExtt1N
      wMT8U7ltQq21fP6u9RXSM0jnInHHwhR6bCjqN0rf6my1crR+WqIW3GmxV0TbChKr
      3sMPR3RcQSLhmvkbk+atIgYpLrG6SRwMJ56j+4v3QHIArJII2YxXhFOBBcvm/mtU
      mEAnhccQu3Nw72kYQQdFVXz5ZD89LMOpfOuTGkyG0cqFAgMBAAGjLjAsMAkGA1Ud
      EwQCMAAwHwYDVR0RBBgwFoIUc3VwZXJmaXNoLmJhZHNzbC5jb20wDQYJKoZIhvcN
      AQELBQADgYEAKgHH4VD3jfwzxvtWTmIA1nwK+Fjqe9VFXyDwXiBnhqDwJp9J+/2y
      r7jbXfEKf7WBS6OmnU+HTjxUCFx2ZnA4r7dU5nIsNadKEDVHDOvYEJ6mXHPkrvlt
      k79iHC0DJiJX36BTXcU649wKEVjgX/kT2yy3YScPdBoN0vtzPN3yFsQ=
      -----END CERTIFICATE-----
    PEM
    output = pipe_output("#{bin}/openssl verify 2>&1", bad_cert, 2)
    assert_match "verification failed", output
    refute_match "error:80000002", output
  end
end
