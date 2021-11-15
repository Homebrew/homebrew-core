class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1l.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1l.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1l.tar.gz"
  # These are for when a new version is released and the old URL stops working:
  mirror "https://www.openssl.org/source/old/1.1.1/openssl-1.1.1l.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/old/1.1.1/openssl-1.1.1l.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/old/1.1.1/openssl-1.1.1l.tar.gz"
  sha256 "0b7a3e5e59c34827fe0c3a74b7ec8baef302b98fa80088d7f9153aa16fa76bd1"
  license "OpenSSL"
  revision 1
  version_scheme 1

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(1\.1(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8f5b0bee61c1570b9f0fc0a21d6c322e904ae7975bdaada5787451d18e9677a6"
    sha256 arm64_big_sur:  "e3d8556cec907ad1e0ea00aebd0b0b516dde06ea3bf24308290ad785cb360a04"
    sha256 monterey:       "9a14367813591b51e30828c7d86499479bc6201954f6b10ed591b40cd3b71cc1"
    sha256 big_sur:        "64d4d83f7d3216f2d3107f966b223d11401a2e9391707d959fbdb5c1bd5fbe0c"
    sha256 catalina:       "eb4e1d96f1a9eac8d096220550e3ca97a46d59747ec2324e2ff74351f8319c2b"
    sha256 mojave:         "add58d2bb5059599029e687d5baf6fd737dff1e5cef7b6c5f4e0fe11b9c8e588"
    sha256 x86_64_linux:   "84bc9412c1620f5607161c5fe2b6e11ff49de96d704595523f7f7c15f1883cf2"
  end

  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  depends_on "ca-certificates"

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz"
      sha256 "0fd90d4efea82d6e262e6933759e85d27cbcfa4091b14bf4042ae20bab528e53"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302175.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302175.tar.gz"
      sha256 "c8c8f5c51ad6d7a858c3b61b8b658d8e789d3da5d300065df0633875b0075e49"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.48.tar.gz"
      mirror "http://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.48.tar.gz"
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
