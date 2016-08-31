class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.21.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.21.tar.bz2"
  sha256 "6b47a3100c857dcab3c60e6152e56a997f2c7862c1b8b2b25adf3884a1ae2276"

  bottle do
    rebuild 1
    sha256 "09ced5d5d38c4c517123e82f7c533ef55b1888498a0f355d70b24636dbe452e7" => :el_capitan
    sha256 "87b9e6e02558be92528772c762db0f7e2dc8b9d275dd23d7a498210535109bce" => :yosemite
    sha256 "f1521ac3df05904c32bdd52173f44d129e565edabdd935515519a087498575c4" => :mavericks
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
      brew install gnupg2

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
