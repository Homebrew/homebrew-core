class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.20.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.20.tar.bz2"
  sha256 "04988b1030fa28ddf961ca8ff6f0f8984e0cddcb1eb02859d5d8fe0fe237edcc"
  revision 1

  bottle do
    sha256 "6b0fe0f18f74c998ffb1e0007c8bf9d10a133447f67f6222cb1d324b65502163" => :el_capitan
    sha256 "e776605dc881882bf2da67c3cf187d8266cd48748d191224bf7cccd78b84ddc6" => :yosemite
    sha256 "b38cad22c27ea36eab4c29501ca7f85769caf56b71e25d8f55e8783bd32e940b" => :mavericks
  end

  depends_on "curl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--program-suffix=1"
    system "make"
    system "make", "check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make", "install"

    # Although gpg2 support should be pretty universal these days
    # keep vanilla `gpg` executables available, at least for now.
    %w[gpg-zip1 gpg1 gpgsplit1 gpgv1].each do |cmd|
      (libexec/"gpgbin").install_symlink bin/cmd => cmd.to_s.sub(/1/, "")
    end
  end

  def caveats; <<-EOS.undent
    All commands have been installed with the suffix '1'.

    If you really need to use these commands with their normal names, you
    can add a "gpgbin" directory to your PATH from your #{shell_profile} like:

        PATH="#{opt_libexec}/gpgbin:$PATH"

    Note that doing so may interfere with GPG-using formulae installed via
    Homebrew.
    EOS
  end

  test do
    (testpath/"gen-key-script").write <<-EOS.undent
      Key-Type: RSA
      Key-Length: 4096
      Subkey-Type: RSA
      Subkey-Length: 4096
      Name-Real: Homebrew Test
      Name-Email: test@example.com
      Expire-Date: 0
    EOS
    system bin/"gpg", "--batch", "--gen-key", "gen-key-script"
    (testpath/"test.txt").write ("Hello World!")
    system bin/"gpg", "--armor", "--sign", "test.txt"
    system bin/"gpg", "--verify", "test.txt.asc"
  end
end
