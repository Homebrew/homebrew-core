class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-3.0.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.0.0.tar.gz"
  sha256 "59eedfcb46c25214c9bd37ed6078297b4df01d012267fe9e9eee31f61bc70536"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a63be68c6f59f218794b6beef367cc137887c1c9efec5facaad53beed9db4d51"
    sha256 arm64_big_sur:  "f62a52f5321f601e49411a9b80c079217cb28e606360a559da448e2673085d44"
    sha256 monterey:       "a5997d602833d5fb5f301cabb053ed30ec6eac5a1cc236b5f6ed045eda6f2af8"
    sha256 big_sur:        "b5a51da4059ef651824d284210f8c6bae62c58d53bedff020f51c24384b6a23a"
    sha256 catalina:       "c6ccff3db9265ab98f190357d8d324ca88a4126e47f5cfebea876a712a1adfba"
    sha256 mojave:         "60eea9f4dd2dc264490e18980ba1cd881877bd194e2cda3564e9fe56e6bdadf4"
    sha256 x86_64_linux:   "6bdb460fc9a6d1b5436a21538866ce56c67956d8647c0efcda10e136dc8f77b9"
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
