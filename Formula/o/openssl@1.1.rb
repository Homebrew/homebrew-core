class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1w.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1w.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1w.tar.gz"
  mirror "https://www.openssl.org/source/old/1.1.1/openssl-1.1.1w.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/old/1.1.1/openssl-1.1.1w.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/old/1.1.1/openssl-1.1.1w.tar.gz"
  sha256 "cf3098950cb4d853ad95c0841f1f9c6d3dc102dccfcacd521d93925208b76ac8"
  license "OpenSSL"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "e49b48327359eb6f1e1a0c67f4810105d803b560cd0d70c7247f2157f7cffe61"
    sha256 arm64_sonoma:   "00fe912a43983918e60fa5b009e81347c7775c6bfbcd89ee067dc293f35547f9"
    sha256 arm64_ventura:  "eaec02db0f43d4f11ff1299ecbcbe182ea30af62b22e5cfaaf6b77d5bbbddbbb"
    sha256 arm64_monterey: "edb44a1452fe8d30491d156b0cdad749027f2daf80d4e0f04953ee2b192f7dc4"
    sha256 sonoma:         "8b6e4ba1f184ffe1f74c66e028887aba08c1810ae7c5ed226fe491a6de8bc8e1"
    sha256 ventura:        "8111bc5385b46990584fa3fc1ecd20b0f0532fa20a7efbef2a5f4ebe2ca5ba2d"
    sha256 monterey:       "aee993c9e2f76f76b6015446c786ca9fbebf20486c34a52d5047a843bb50fc30"
    sha256 x86_64_linux:   "076d0f3ec7d6938cd2b360ca39a4f70395214d0a545fe0fa8a6c5d23659b65c2"
  end

  keg_only :versioned_formula

  # See: https://www.openssl.org/policies/releasestrat.html
  disable! date: "2024-10-24", because: :unsupported

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.44.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.44.tar.gz"
      sha256 "7eb591ea6b499ece6745ff3e80e60cee669f0037f9ccbc4e4511425f593e5297"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302195.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302195.tar.gz"
      sha256 "b390bb23592e0b946c95adbb3c30b11bc634a286b2847be611ad929c57e39a6c"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.70.tar.gz"
      sha256 "f108bd46420d2f00d242825f865b0f68851084924924f92261d684c49e3e7a74"
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

    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    system "make", "test"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| openssldir/subdir/".keepme" }
  end

  def openssldir
    etc/"openssl@1.1"
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
    assert_path_exists pkgetc/"openssl.cnf", "OpenSSL requires the .cnf file for some functionality"

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
