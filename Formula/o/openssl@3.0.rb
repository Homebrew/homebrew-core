class OpensslAT30 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl-library.org"
  url "https://github.com/openssl/openssl/releases/download/openssl-3.0.21/openssl-3.0.21.tar.gz"
  sha256 "617e29af8e421f46649484a4937e48c685e47f46488167c982f88bc4ec1d522f"
  license "Apache-2.0"

  livecheck do
    url "https://openssl-library.org/source/"
    regex(/href=.*?openssl[._-]v?(3\.0(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d3cc1ee8b295fec57f78eb337ce5f14f99f6dd55d31aafeb54e6c54fdcd3d8cf"
    sha256 arm64_sequoia: "2c3f0cf3de87f2828963b7e7ce6b655e15025a54d37ba375b0eec30af46f4947"
    sha256 arm64_sonoma:  "a6cb61370578baed8a2465753dd5e4b851842ed4cd43537ff43fc9f5f789181b"
    sha256 sonoma:        "347ac55b827131428725ded872f7891ec7fc4be2ebe5311cedb700a880029fae"
    sha256 arm64_linux:   "739cb6e8d5f7831ac0752f5fb6cb8e6be32cc40842c75a151f45e4dda74ddeb3"
    sha256 x86_64_linux:  "2e44d7b402d2429114f09c8f72c2aefb5e3b7f933bf9ca819a700fab0ae468d4"
  end

  keg_only :versioned_formula

  # See: https://www.openssl.org/policies/releasestrat.html
  deprecate! date: "2026-09-07", because: :unsupported

  depends_on "ca-certificates" => :no_linkage

  on_linux do
    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.52.tar.gz"
      sha256 "8fe65cfc0261ed3c8a4395f0524286f5719669fe305f9b03b16cf3684d62cd70"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302220.tar.gz"
      sha256 "bbca30d9fb64a67a28ccd9086cdc08cdb6046423fa032d9101f978d7ccd46cf9"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.78.tar.gz"
      sha256 "43b33c20f8d82dba7cc48f8cd702f8fc9811e9d07880886dfd31b7077bd4a3a6"
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

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = formula_opt_bin("perl")/"perl" if which("perl") == formula_opt_bin("perl")/"perl"

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
    system "make", "HARNESS_JOBS=#{ENV.make_jobs}", "test"

    # Prevent `brew` from pruning the `certs` and `private` directories.
    touch %w[certs private].map { |subdir| openssldir/subdir/".keepme" }
  end

  def openssldir = pkgetc

  post_install_steps do
    ln_sf "cert.pem", "cert.pem",
          source_formula: "ca-certificates",
          source_base:    :formula_pkgetc,
          target_base:    :pkgetc
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
