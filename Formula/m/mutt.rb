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
  url "https://ftp.osuosl.org/pub/mutt/mutt-2.4.1.tar.gz"
  mirror "http://ftp.mutt.org/pub/mutt/mutt-2.4.1.tar.gz"
  sha256 "5624321f0b1cc1eff6cab9ef08f25954ff64c51b33d4bf3b99484cf1edd8cfff"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.mutt.org/download.html"
    regex(/href=.*?mutt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b939906be32476b3ddc1a8a9a2a0fedd00f7b0cc35a721fcf79fa5f9c53b3580"
    sha256 arm64_sequoia: "8aef12e86e2d4efbe49e3e37bc89bdaea897904a47a88c3ee8c075a5ac18558d"
    sha256 arm64_sonoma:  "d87bfb4ace1ee4f8bc5a9a5cea48d38fba3be68297a146c1d16213586b27bd34"
    sha256 sonoma:        "1290157843792711b374bd4c09786a1b4ebc719742988f0b26b84348d0338385"
    sha256 arm64_linux:   "82710e5c9d1bd2ae7b8f429b8542ca36afcd2d776c18d2d2f717a77c9110a7f6"
    sha256 x86_64_linux:  "fdb2518b71f57a1bbaa760bc3694618e54e70af30a1213d58f263aca02c95a8f"
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
