class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.21.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.21.tar.bz2"
  sha256 "7aead8a8ba75b69866f583b6c747d91414d523bfdfbe9a8e0fe026b16ba427dd"

  bottle do
    sha256 "88a921fc98b9e9c85ec2cb000ffdf799608e2fe3a6fb751da993ceeeb488885b" => :sierra
    sha256 "888de7f194f0306fbaa2fc99645806de2a3650535aefa9d710246397b537073a" => :el_capitan
    sha256 "e7db54f2ea04d7813701087373a61f9f207a7e52404dd61c1b8ab985f6d86d5b" => :yosemite
  end

  option "with-gpgsplit", "Additionally install the gpgsplit utility"
  option "with-gpg-zip", "Additionally install the gpg-zip utility"
  option "without-libusb", "Disable the internal CCID driver"

  deprecated_option "without-libusb-compat" => "without-libusb"

  depends_on "pkg-config" => :build
  depends_on "sqlite" => :build if MacOS.version == :mavericks
  depends_on "npth"
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pinentry"
  depends_on "gettext"
  depends_on "adns"
  depends_on "libusb" => :recommended
  depends_on "readline" => :optional
  depends_on "encfs" => :optional

  # Upstream commit 16 May 2017 "Suppress error for card availability check."
  # See https://dev.gnupg.org/rGa8dd96826f8484c0ae93c954035b95c2a75c80f2
  patch do
    url "https://files.gnupg.net/file/data/4cbbk5wdkpo72hbwah6g/PHID-FILE-sxw2ecnjqxzopc2wimxp/file"
    sha256 "3adb7fd095f8bc29fd550bf499f5f198dd20e3d5c97d5bcb79e91d95fd53a781"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --enable-symcryptrun
      --with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry
    ]

    args << "--disable-ccid-driver" if build.without? "libusb"
    args << "--with-readline=#{Formula["readline"].opt_prefix}" if build.with? "readline"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Add symlinks from gpg2 to unversioned executables, replacing gpg 1.x.
    bin.install_symlink "gpg2" => "gpg"
    bin.install_symlink "gpgv2" => "gpgv"
    man1.install_symlink "gpg2.1" => "gpg.1"
    man1.install_symlink "gpgv2.1" => "gpgv.1"

    bin.install "tools/gpgsplit" if build.with? "gpgsplit"
    bin.install "tools/gpg-zip" if build.with? "gpg-zip"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  def caveats; <<-EOS.undent
    Once you run this version of gpg you may find it difficult to return to using
    a prior 1.4.x or 2.0.x. Most notably the prior versions will not automatically
    know about new secret keys created or imported by this version. We recommend
    creating a backup of your `~/.gnupg` prior to first use.

    For full details on each change and how it could impact you please see
      https://www.gnupg.org/faq/whats-new-in-2.1.html
    EOS
  end

  test do
    (testpath/"batch.gpg").write <<-EOS.undent
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
