class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl-library.org"
  url "https://github.com/openssl/openssl/releases/download/openssl-3.4.0/openssl-3.4.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/openssl-3.4.0.tar.gz"
  sha256 "e15dda82fe2fe8139dc2ac21a36d4ca01d5313c75f99f46c4e8a27709b7294bf"
  license "Apache-2.0"

  livecheck do
    url "https://openssl-library.org/source/"
    regex(/href=.*?openssl[._-]v?(3(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "bf2e6c5cb39433b00fa2aaf4a6db681814149f62c01f04d381c3c64cd32c1bd3"
    sha256 arm64_sonoma:  "706b2f224c9519816d987e28ecfae9cfb41d99b728e237ef98fa1c0698d1f626"
    sha256 arm64_ventura: "4b27265cc378fad113f0ab2f8609098c3ac84f79a76ad68a03d6af96f4eb2380"
    sha256 sonoma:        "28e2abc928e8afd0c58303de69dab5e4ec8663c5591fe3c425ad9177bf377ded"
    sha256 ventura:       "9017cd4ac641f4a961b27328bf519cbed91d5e3be2ae8e7f833b866412697d2f"
    sha256 x86_64_linux:  "424afb56cdd116602c373db5ff55fbaef0865775cfacdc18c5e6a71aa24845e9"
  end

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.50.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.50.tar.gz"
      sha256 "79b6acdc444f1924cd4c2e9ed868bdc6e09580021aca8ff078ede2ffef8a6f54"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302201.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302201.tar.gz"
      sha256 "956185dc96c1f2942f310a549a2b206cc5dd1487558f4e36d87af7a8aacbc87c"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
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
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate pkgetc/"openssl.cnf", :exist?, "OpenSSL requires the .cnf file for some functionality"
    assert_predicate openssldir/"certs", :exist?, "OpenSSL throws confusing errors when this directory is missing"

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
