# NOTE: Mutt has a large number of non-upstream patches available for
# it, some of which conflict with each other. These patches are also
# not kept up-to-date when new versions of mutt (occasionally) come
# out.
#
# To reduce Homebrew's maintenance burden, patches are not accepted
# for this formula. The NeoMutt project has a Homebrew tap for their
# patched version of Mutt: https://github.com/neomutt/homebrew-neomutt

class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage "http://www.mutt.org/"
  url "https://ftp.osuosl.org/pub/mutt/mutt-2.4.2.tar.gz"
  mirror "http://ftp.mutt.org/pub/mutt/mutt-2.4.2.tar.gz"
  sha256 "2703ff1a51a99c3163d4fd998ac22e982bbd5493d512a7c5bde716a8adba0394"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.mutt.org/download.html"
    regex(/href=.*?mutt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "695ca4f237e987b8121e9997a05b73d83654394624f737e45b5bb733d8d35a6f"
    sha256 arm64_tahoe:       "85472b3588f5f0d7468c28564740d94f4ba8b76003f719d20394795cdabd3cd2"
    sha256 arm64_sequoia:     "d0e62c89594c32f7635a125b454d79dc2b38104d2d64d57456a45e32b65103ca"
    sha256 arm64_sonoma:      "91ed9e4e9b0d6885c48355265dd724e6efd685639e4c34e1a2560db10801fdae"
    sha256 arm64_linux:       "dac27c9ff346a88230810b1084725f3bbd3f60fc1de3795803c914b4bcc1e263"
    sha256 x86_64_linux:      "543d6134dfaa023dd55d1833c0d793573634e6ec448bbfcc7490c4ef220cbaa2"
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "tin", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    user_in_mail_group = Etc.getgrnam("mail").mem.include?(ENV["USER"])
    effective_group = Etc.getgrgid(Process.egid).name

    # NOTE: For hcache backend choice:
    # * Kyoto Cabinet, Tokyo Cabinet, QDBM and Berkeley DB may be unmaintained or low maintenance
    # * Remaining options are GDBM and LMDB. NeoMutt (fork) now recommends LMDB. Gentoo also
    #   recommends LMDB as fastest for Mutt, https://wiki.gentoo.org/wiki/Mutt#Header_cache_backends
    args = %W[
      --disable-warnings
      --enable-gpgme
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-idn2
      --with-lmdb
      --with-sasl
      --with-ssl=#{formula_opt_prefix("openssl@3")}
    ]

    configure = build.head? ? "./prepare" : "./configure"
    system configure, *args, *std_configure_args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = #{effective_group}" unless user_in_mail_group

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  def caveats
    <<~EOS
      mutt_dotlock(1) has been installed, but does not have the permissions to lock
      spool files in /var/mail. To grant the necessary permissions, run

        sudo chgrp mail #{bin}/mutt_dotlock
        sudo chmod g+s #{bin}/mutt_dotlock

      Alternatively, you may configure `spoolfile` in your .muttrc to a file inside
      your home directory.
    EOS
  end

  test do
    system bin/"mutt", "-D"
    touch "foo"
    system bin/"mutt_dotlock", "foo"
    system bin/"mutt_dotlock", "-u", "foo"
  end
end
