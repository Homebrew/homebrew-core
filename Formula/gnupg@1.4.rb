class GnupgAT14 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  sha256 "c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gnupg/"
    regex(/href=.*?gnupg[._-]v?(1\.4(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d35c8557e2e77c6074a75bf4f4e575bd0a24ed57fbd061f9bd2a06d58bf8415c"
    sha256 arm64_big_sur:  "30169aa8ef5373a4d5b36ee5714bd7e34d7222d02ad090bf3094b92b1c203bd6"
    sha256 monterey:       "d010750043549f48f60a95d8b6c02bc5754168d09f298a4dace80eb84ccacd52"
    sha256 big_sur:        "408013c7748d2b6de6c09520e4b3948a493fcc338624493050c081e200820390"
    sha256 catalina:       "3796803df0956a54dfc5ed26f17a92791622c4ddc6b0dfa6b8fabc0f65afdd0d"
    sha256 mojave:         "32f23f8ceec79b8073f8b69a2c7f1278adf9020c00d78d2cd9d07c1e5f3bdb89"
    sha256 high_sierra:    "dbd43b52f11e65c2bb6dadf3adbf8ccf7f740af33b56e4d8c8b037611840f127"
    sha256 sierra:         "abc1e142397fbe833f2f7c5f71409d925ce690506d77296f7f3d41656a0791f2"
    sha256 el_capitan:     "397c92b88bd189ef61dfb01d5fe2e27e0477a63de64a713ffb883eb799dcbb87"
    sha256 x86_64_linux:   "4e742c3b7160f0cdc5d4399857508ed58d3e43abb7f41bc9f173b5b83c12bccf"
  end

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-asm
      --program-suffix=1
      --with-libusb=no
    ]

    system "./configure", *args
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
      add a "gpgbin" directory to your PATH from your #{shell_profile} like:

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
