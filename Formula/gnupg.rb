class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.21.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.21.tar.bz2"
  sha256 "7aead8a8ba75b69866f583b6c747d91414d523bfdfbe9a8e0fe026b16ba427dd"

  bottle do
    sha256 "05f9ab32a72ea08558ff601c3129bd28f96254be825166af32071e9d85ad4e96" => :sierra
    sha256 "d04710133f5b4024613b6050e71e18320ec7bc5d1f3ece9881670b41e7dabc88" => :el_capitan
    sha256 "4c652325ce87064d12a927e4ee2584e1feb0f27b2e7288b4b9d1d19c78712797" => :yosemite
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
    system "make", "install"

    # 2.1.21 has a nasty regression inside sandboxed environments.
    # See previous: https://dev.gnupg.org/T2980
    # system "make", "check"

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
