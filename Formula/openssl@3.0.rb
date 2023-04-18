class OpensslAT30 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-3.0.8.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.0.8.tar.gz"
  sha256 "6c13d2bf38fdf31eac3ce2a347073673f5d63263398f1f69d0df4a41253e4b3e"
  license "Apache-2.0"

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(3\.0(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "110f3c266102f0fa0c82be4cf3ffa6603fed29aa6e1711741672bb6bfe769805"
    sha256 arm64_monterey: "553ef2386034113e3156593291b331c130f459c0a8d148fb411ea084e036f1e7"
    sha256 arm64_big_sur:  "46aba17269f861d709a708914347d65a0a126781c1baebcbd7e18a8adede576d"
    sha256 ventura:        "984d024ec443bd77ea8e83568251140fbbd710a4ec48670903b1ae5809baa1c5"
    sha256 monterey:       "bf169df9308d0f428e22738863b85464af92f970fe823a24ae7a150d79b2bc24"
    sha256 big_sur:        "f62ab4c4fd6f33b32ba44d23482fb998b0ac8b1ca07c8e3083ccfe94fe2d1bd9"
    sha256 x86_64_linux:   "81d153bc01a5863e5430a6d46e3f6e4f4534d0dcb06710befa399a4c1ffbb961"
  end

  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  depends_on "ca-certificates"

  on_linux do
    keg_only "it conflicts with the `openssl@1.1` formula"

    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.44.tar.gz"
      sha256 "7eb591ea6b499ece6745ff3e80e60cee669f0037f9ccbc4e4511425f593e5297"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302194.tar.gz"
      sha256 "23d4965eb32504c8c7670563ce784ce5dc043c2572d771ce4a584558d6869f48"
    end

    resource "ExtUtils::MakeMaker" do
      url "https://cpan.metacpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.68.tar.gz"
      sha256 "270238d253343b833daa005fb57a3a5d8916b59da197698a632b141e7acad779"
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
    etc/"openssl@3.0"
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
