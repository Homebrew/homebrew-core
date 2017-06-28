class GnupgAT14 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.21.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.21.tar.bz2"
  sha256 "6b47a3100c857dcab3c60e6152e56a997f2c7862c1b8b2b25adf3884a1ae2276"

  bottle do
    sha256 "75e3d0b64aa7c8b0a1909401881542b82890380e36ca61711cf68e584387702c" => :sierra
    sha256 "53c0d078cb7858cc138b976d7248368678171475a1d42afd0115be067c2c9ae5" => :el_capitan
    sha256 "e3c430f6e012f9033c3cd704ce599b30e5e557fe459b92afc222753640b43fdc" => :yosemite
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

  def caveats; <<-EOS.undent
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
    (testpath/"batchgpg").write <<-EOS.undent
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
