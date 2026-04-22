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
  url "https://ftp.osuosl.org/pub/mutt/mutt-2.3.1.tar.gz"
  mirror "http://ftp.mutt.org/pub/mutt/mutt-2.3.1.tar.gz"
  sha256 "470d7b0e3d134a05fb8064dedd74771b06bcd639c80fccd7773dc322aafbb7b6"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://www.mutt.org/download.html"
    regex(/href=.*?mutt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7b3f6bd8f446e44e5f3bc416d76ebddb6a1fc2aa5f0d0a90f658456c19c8a3c7"
    sha256 arm64_sequoia: "682e5ff1b3de2927ca3b2392f9bb31d9512ba53d670a4d1443cabb95c705d5f9"
    sha256 arm64_sonoma:  "307538a7057f977b2e1cf2dc58201b3ed4c5e61bf893eb00f8a3b8a43642b6a0"
    sha256 sonoma:        "96adf1eaa6932024d451badf4514fc857583552f21d6c93d4e04bacd9558d659"
    sha256 arm64_linux:   "aefee900cfcc4426a648d15d9e5384d9e7c555d4da2353280f0d1e05260cbbe6"
    sha256 x86_64_linux:  "034e669358e9711e96af30a0f01e0747d8fea84f53a39d3865fba081f25e8644"
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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
