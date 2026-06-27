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
  url "https://ftp.osuosl.org/pub/mutt/mutt-2.4.0.tar.gz"
  mirror "http://ftp.mutt.org/pub/mutt/mutt-2.4.0.tar.gz"
  sha256 "8f6ca2ef42f8f07cdc8ec391e8aa41a702490eae55ac72016b0b94ddf44ae292"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.mutt.org/download.html"
    regex(/href=.*?mutt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "583d2f9f185f759353e0043d3949b7e638cf4d0561c31f60f230b1f89d45cf73"
    sha256 arm64_sequoia: "278d34cad76edf2bc9737ca0d6dae4679224119dab01cace556c422674a2f43b"
    sha256 arm64_sonoma:  "867fd98d847854606e1dad1a91bfb330f66679c2f43725076b360c9b2e31fd97"
    sha256 sonoma:        "eca1a996bcad104f2418feb012484e5e4ad3003f86d900a2d31e47d2bb296e15"
    sha256 arm64_linux:   "39a813e4ee156f610c89f5d231c310893e38deabbad5ad9edcea44430440aad7"
    sha256 x86_64_linux:  "062449bfd8b45ec93d42ec205794e69ab84513cbf5ec52332f8b5b4ca0810851"
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
