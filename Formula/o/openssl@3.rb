class OpensslAT3 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-3.1.4.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.1.4.tar.gz"
  mirror "https://www.openssl.org/source/old/3.1/openssl-3.1.4.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/old/3.1/openssl-3.1.4.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-3.1.4.tar.gz"
  mirror "http://www.mirrorservice.org/sites/ftp.openssl.org/source/old/3.1/openssl-3.1.4.tar.gz"
  sha256 "840af5366ab9b522bde525826be3ef0fb0af81c6a9ebd84caa600fea1731eee3"
  license "Apache-2.0"

  option "with-universal2", "Builds Universal2 binary (ARM64 and Intel64)"

  livecheck do
    url "https://www.openssl.org/source/"
    regex(/href=.*?openssl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9d4a5ce04bbdd512930efe9726c373c492598af4bdd4f6378a8ab93d99b150d0"
    sha256 arm64_ventura:  "1ff0549b8fc8e8f279a6272009c980762d25ca1cb3e8816fd89fcd8eb129fcf5"
    sha256 arm64_monterey: "81f024814ded9921e2d3d57782afb253a23c77530a5cfa17b86d6353436a428b"
    sha256 sonoma:         "42038036c3c79c86f73e084d089015efcb031914d32d3cc92a8ffa264ee17bf7"
    sha256 ventura:        "92ca3dee40d93846740172ef9d7e64587a57d2948289c2015e0373eab5140f82"
    sha256 monterey:       "1afee5b2ecce7edc8417799ead32399f3846b03327a0d4876312c85a2504e061"
    sha256 x86_64_linux:   "9d25623d60634b81347e22c20e81d830b91b8f80557c77dca9ecdcedb98d43c6"
  end

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


    # This provides Universal2 support in a less-then-elegant way, it does so by first compiling
    # and installing the opposing architecture, then moves the library out-of-the-way (by rename)
    # then builds and installs the correct arch (normal path ends here) then moves that lib out of
    # the way via rename, then finally uses lipo to combine them
    if build.with? "universal2" and OS.mac?
      fat_tmp_path = File.join(buildpath, "fat_binaries")

      FileUtils.mkpath fat_tmp_path

      if Hardware::CPU.arm?
        alternate_arch_args = %W[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128 no-asm]
        this_arch = :x86_64
      elsif Hardware::CPU.intel?
        alternate_arch_args = %W[darwin64-arm64-cc enable-ec_nistp_64_gcc_128]
        this_arch = :arm64
      else
        fail "Cannot build Universal2, current architecture #{Hardware::CPU.arch} is not Intel (#{Hardware::CPU::INTEL_ARCHS}) or ARM (#{Hardware::CPU::ARM_ARCHS}"
      end

      system "perl", "./Configure", *(configure_args + alternate_arch_args)
      system "make"
      system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
      #system "make", "test"

      move_fat_binaries(fat_tmp_path, this_arch)
    end

    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    #system "make", "test"

    if build.with? "universal2" and OS.mac?
      move_fat_binaries(fat_tmp_path, Hardware::CPU.arch)

      @all_libraries.each do |final_lib, fat_libs|
        FileUtils.rm final_lib
        system "lipo", "-create", *fat_libs, "-output", File.join(self.lib, final_lib)
      end

      system "make", "test"
    end

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

  private

  def move_fat_binaries(tmp_dir, arch)
    @all_libraries ||= {}

    libraries_generated = Dir.glob(["*.dylib", "*.a", ".so"], base: self.lib)

    libraries_generated.each do |single_lib|
      lib_full_path = File.join(self.lib, single_lib)
      base_name = File.basename(lib_full_path)
      extension = File.extname(lib_full_path)
      fat_library = File.join(tmp_dir, "#{base_name}.#{arch}#{extension}")
      FileUtils.cp(lib_full_path, fat_library)
      @all_libraries[single_lib] ||= []
      @all_libraries[single_lib] << fat_library
    end

    @all_libraries
  end
end
