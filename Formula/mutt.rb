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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-2.2.10.tar.gz"
  sha256 "4d773f22422f79096f7b94b57bee45654ad9a25165dbb36463c58295b4cd3d88"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "84c9fb99a748ea2ba9802cb5a3045dbc48dc4db4130fb440ba21887a3f1f73d6"
    sha256 arm64_monterey: "7a7d134940105af10f2ab19f906af3db5279e796d554da49276894bf12b86169"
    sha256 arm64_big_sur:  "8d274ef46f219d9f1d962cea42b09a709f806224548929d2c0381276f4289ef8"
    sha256 ventura:        "0af7138ecfcc4583634cb89a2d8ae5c306c7703634c60d0f52a8582bc03661e0"
    sha256 monterey:       "f60835d5396bdadfe9c90c43d5ff276d34199b8ba1197238237dd570ab9eae23"
    sha256 big_sur:        "4bea848f974ae99a98096c462e5bc1c597d56322ff7fb3687a5b4291b57843a2"
    sha256 x86_64_linux:   "bd874113ef66637acd6fd628345a910345854689745eb003afa174af525fe5b5"
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
  depends_on "openssl@3"
  depends_on "tokyo-cabinet"

  uses_from_macos "bzip2"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "ncurses"
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
