class GnupgAT14 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  sha256 "c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba"
  revision 1

  bottle do
    sha256 "32f23f8ceec79b8073f8b69a2c7f1278adf9020c00d78d2cd9d07c1e5f3bdb89" => :mojave
    sha256 "dbd43b52f11e65c2bb6dadf3adbf8ccf7f740af33b56e4d8c8b037611840f127" => :high_sierra
    sha256 "abc1e142397fbe833f2f7c5f71409d925ce690506d77296f7f3d41656a0791f2" => :sierra
    sha256 "397c92b88bd189ef61dfb01d5fe2e27e0477a63de64a713ffb883eb799dcbb87" => :el_capitan
  end

  depends_on "curl" if MacOS.version <= :mavericks

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

  def caveats; <<~EOS
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
