class GnupgAT14 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
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
    sha256 arm64_tahoe:    "4da60752860e988316bff74732f1dfa5bb443527062d6e3b825d0c262eff9273"
    sha256 arm64_sequoia:  "3feee712ec2e654beb69d4d4270faa84490981094c1592d2fad3793229a4dfcb"
    sha256 arm64_sonoma:   "bc3e33a439e34c3e1e39a6e3d38c507d000f6cbc241ea0aa92977ffcc5eda72e"
    sha256 arm64_ventura:  "0745d4b4468cfecd559c6ddd3aa81582bde9f1def99761e8bf7989ddb9a76abf"
    sha256 arm64_monterey: "d35c8557e2e77c6074a75bf4f4e575bd0a24ed57fbd061f9bd2a06d58bf8415c"
    sha256 arm64_big_sur:  "30169aa8ef5373a4d5b36ee5714bd7e34d7222d02ad090bf3094b92b1c203bd6"
    sha256 sonoma:         "591c85555be72806574e292e42a7a44d6f1bff7f9747c50cba4164b85f4dc3fd"
    sha256 ventura:        "d1beb68c6abb3a1d249621c8995d8e26bd1c8792260f36407c47627f84c84668"
    sha256 monterey:       "d010750043549f48f60a95d8b6c02bc5754168d09f298a4dace80eb84ccacd52"
    sha256 big_sur:        "408013c7748d2b6de6c09520e4b3948a493fcc338624493050c081e200820390"
    sha256 catalina:       "3796803df0956a54dfc5ed26f17a92791622c4ddc6b0dfa6b8fabc0f65afdd0d"
    sha256 arm64_linux:    "a0254e4bb280c669c76df2edea0ddf9ded0681aec3c2a220816390c7e142925c"
    sha256 x86_64_linux:   "4e742c3b7160f0cdc5d4399857508ed58d3e43abb7f41bc9f173b5b83c12bccf"
  end

  uses_from_macos "zlib"

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
