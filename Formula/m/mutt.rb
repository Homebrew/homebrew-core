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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-2.2.13.tar.gz"
  sha256 "eb23faddc1cc97d867693f3a4a9f30949ad93765ad5b6fdae2797a4001c58efb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "40c414cbb65f0e9be27d487c9b7c87c63a822060e0afcc3f815848db10909892"
    sha256 arm64_ventura:  "7d0e947b105c9787a9c90f97ff52ac4c89614de091af864c304cef72ce7a8350"
    sha256 arm64_monterey: "87c4c4462ef88fd861ca8eb19611206b0cdb4175b478af24dba1448be962fc5a"
    sha256 sonoma:         "83fc9e8ecb09b0e5face8b52265b0fcf862d66de53be933285884beb458c139f"
    sha256 ventura:        "26067cb236bc01f97b58900574731fbc39d56fe9d8547a48dfe433912a10f385"
    sha256 monterey:       "06b8ad27c9e37f1bf2f5a2bbbeadd4f9c2f48fb345b665e30532fc7626f29510"
    sha256 x86_64_linux:   "d4c0e1f95a35b53d50ad2c0e1fed4cbea20d72092a3deaa7d99277031ed68085"
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git", branch: "master"

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "tokyo-cabinet"

  uses_from_macos "bzip2"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  conflicts_with "tin", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    user_in_mail_group = Etc.getgrnam("mail").mem.include?(ENV["USER"])
    effective_group = Etc.getgrgid(Process.egid).name

    args = %W[
      --disable-dependency-tracking
      --disable-warnings
      --prefix=#{prefix}
      --enable-debug
      --enable-gpgme
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-idn2
      --with-sasl
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-tokyocabinet
    ]

    system "./prepare", *args
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
