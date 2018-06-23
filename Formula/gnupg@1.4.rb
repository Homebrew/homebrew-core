class GnupgAT14 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
  sha256 "c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba"

  bottle do
    sha256 "06712329d11b029b7e1fcc0064d72865caa5e65c93fb39ccababc67320991f8c" => :high_sierra
    sha256 "1e07e7c1deabd13be0b752bfbc926a14c832fccb0f88aca34f057142fd61428f" => :sierra
    sha256 "63ec421f1def0a57f80228c9efbe70521e99bc10c9f30abd90ff3bfa067de14d" => :el_capitan
  end

  depends_on "curl" if MacOS.version <= :mavericks
  depends_on "libusb-compat" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-asm
      --program-suffix=1
    ]
    args << "--with-libusb=no" if build.without? "libusb-compat"

    system "./configure", *args
    system "make"
    system "make", "check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make", "install"

    # https://lists.gnupg.org/pipermail/gnupg-devel/2016-August/031533.html
    inreplace bin/"gpg-zip1", "GPG=gpg", "GPG=gpg1"

    # Although gpg2 support should be pretty universal these days
    # keep vanilla `gpg` executables available, at least for now.
    %w[gpg-zip1 gpg1 gpgsplit1 gpgv1].each do |cmd|
      (libexec/"gpgbin").install_symlink bin/cmd => cmd.to_s.sub(/1/, "")
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
