class GnupgAT21 < Formula
  desc "GNU Privacy Guard: a free PGP replacement"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.19.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.19.tar.bz2"
  sha256 "46cced1f5641ce29cc28250f52fadf6e417e649b3bfdec49a5a0d0b22a639bf0"

  bottle do
    sha256 "ee987dda5cb9a4d128da093096460c0e4d728a27d03cd68e950f50f3619fa84f" => :sierra
    sha256 "0acf9dab68b75ffb1fba25aa077dbda6b9b89b1441b8fef8f97a95d41005bce6" => :el_capitan
    sha256 "b6ef2a5a322fa40ac7dd4fbf362ab0b55e635d127207e0ec40f9ea2a0eb96bb4" => :yosemite
  end

  keg_only :versioned_formula

  option "with-gpgsplit", "Additionally install the gpgsplit utility"
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
  depends_on "homebrew/fuse/encfs" => :optional

  # ssh-import.scm fails during "make check" for sandboxed builds
  # Reported 1 Mar 2017 https://bugs.gnupg.org/gnupg/issue2980
  patch :DATA

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

    # Adjust package name to fit our scheme of packaging both gnupg 1.x and
    # and 2.1.x and gpg-agent separately.
    inreplace "configure" do |s|
      s.gsub! "PACKAGE_NAME='gnupg'", "PACKAGE_NAME='gnupg2'"
      s.gsub! "PACKAGE_TARNAME='gnupg'", "PACKAGE_TARNAME='gnupg2'"
    end

    system "./configure", *args

    system "make", "install"

    # "make check" cannot run before "make install"
    # Reported 1 Mar 2017 https://bugs.gnupg.org/gnupg/issue2979
    system "make", "check"

    bin.install "tools/gpgsplit" => "gpgsplit2" if build.with? "gpgsplit"

    # Move man files that conflict with 1.x.
    mv share/"doc/gnupg2/FAQ", share/"doc/gnupg2/FAQ21"
    mv share/"doc/gnupg2/examples/gpgconf.conf", share/"doc/gnupg2/examples/gpgconf21.conf"
    mv share/"info/gnupg.info", share/"info/gnupg21.info"
    mv man7/"gnupg.7", man7/"gnupg21.7"
  end

  def post_install
    (var/"run").mkpath
  end

  def caveats; <<-EOS.undent
    Once you run the new gpg2 binary you will find it incredibly
    difficult to go back to using `gnupg2` from Homebrew/Homebrew.
    The new 2.1.x moves to a new keychain format that can't be
    and won't be understood by the 2.0.x branch or lower.

    If you use this `gnupg21` formula for a while and decide
    you don't like it, you will lose the keys you've imported since.
    For this reason, we strongly advise that you make a backup
    of your `~/.gnupg` directory.

    For full details of the changes, please visit:
      https://www.gnupg.org/faq/whats-new-in-2.1.html

    If you are upgrading to gnupg21 from gnupg2 you should execute:
      `killall gpg-agent && gpg-agent --daemon`
    After install. See:
      https://github.com/Homebrew/homebrew-versions/issues/681
    EOS
  end

  test do
    system bin/"gpgconf"
  end
end

__END__
diff --git a/tests/openpgp/gpg-agent.conf.tmpl b/tests/openpgp/gpg-agent.conf.tmpl
index 355915015..4340a0498 100644
--- a/tests/openpgp/gpg-agent.conf.tmpl
+++ b/tests/openpgp/gpg-agent.conf.tmpl
@@ -1,3 +1,4 @@
 allow-preset-passphrase
 no-grab
 enable-ssh-support
+disable-scdaemon
