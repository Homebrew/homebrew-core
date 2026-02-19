class GnupgAT14 < Formula
  desc "GNU Privacy Guard (OpenPGP)"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  sha256 "c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(1\.4(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4ca96fcb6e85fd587e3716a10c8aadc3117fd1055e368627efb8eb8ecbbd486f"
    sha256 arm64_sequoia: "d7ac6385a597f2793c1da1f6a037d44009827fe6f8e92780121ba6a7d66c422a"
    sha256 arm64_sonoma:  "9fc6d326a446c03cea4d945563169f5209a8585a5a882f7df7550dbb58664c4b"
    sha256 sonoma:        "7721cebd4f645feeb8b7587177c0553377a1589ab89023dced381afdec98788f"
    sha256 arm64_linux:   "15bb19626345f79fdb0ad5be25352cb1622d71de933e907384195dc3ada271af"
    sha256 x86_64_linux:  "7f184495fcd172935dea746755da90bb1fe3fb04e0b59e1faecc426a8325b8bc"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `mpi_debug_mode'; mpicalc.o:(.bss+0x344): first defined here
    # multiple definition of `memory_stat_debug_mode'; mpicalc.o:(.bss+0x348): first defined here
    # multiple definition of `memory_debug_mode'; mpicalc.o:(.bss+0x34c): first defined here
    # multiple definition of `iobuf_debug_mode'; mpicalc.o:(.bss+0x350): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = %w[
      --disable-silent-rules
      --disable-asm
      --program-suffix=1
      --with-libusb=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make", "install"

    # https://lists.gnupg.org/pipermail/gnupg-devel/2016-August/031533.html
    inreplace bin/"gpg-zip1", "GPG=gpg", "GPG=gpg1"

    # link to libexec binaries without the "1" suffix
    # gpg1 will call them without the suffix when it needs to
    %w[curl finger hkp ldap].each do |cmd|
      cmd.prepend("gpgkeys_")
      (libexec/"gnupg").install_symlink (cmd + "1") => cmd
    end

    # Although gpg2 support should be pretty universal these days
    # keep vanilla `gpg` executables available, at least for now.
    %w[gpg-zip gpg gpgsplit gpgv].each do |cmd|
      (libexec/"gpgbin").install_symlink bin/(cmd + "1") => cmd
    end
  end

  def caveats
    <<~EOS
      This formula does not install either `gpg` or `gpgv` executables into
      the PATH.

      If you simply require `gpg` and `gpgv` executables without explicitly
      needing GnuPG 1.x we recommend:
        brew install gnupg

      If you really need to use these tools without the "1" suffix you can
      add a "gpgbin" directory to your PATH like:
          PATH="#{opt_libexec}/gpgbin:$PATH"

      Note that doing so may interfere with GPG-using formulae installed via
      Homebrew.
    EOS
  end

  test do
    (testpath/"batchgpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %commit
    EOS
    system bin/"gpg1", "--batch", "--gen-key", "batchgpg"
    (testpath/"test.txt").write "Hello World!"
    system bin/"gpg1", "--armor", "--sign", "test.txt"
    system bin/"gpg1", "--verify", "test.txt.asc"
  end
end
