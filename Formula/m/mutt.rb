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
    sha256 arm64_sonoma:   "0295e7d5aef519e73a62f4070123ca677bbc02e3b39a5851b8258720b545aa62"
    sha256 arm64_ventura:  "20fce7f33fa97a819b5178ac81fd7d2ff755b3606892589e2419ec8b16c051ef"
    sha256 arm64_monterey: "a6c31c9d9fc9003d5b7b54d94c558babe0a24f865b0cee7c5873c7e16acd626c"
    sha256 arm64_big_sur:  "37e48aa656c0713c6d337142efb5cdf94de8107fc99357e3c1c1e2056b3fd1b6"
    sha256 sonoma:         "5c7750bd5ec725e32eebb36f235d4f46b732f7a796e803ea75453ac0c9a7e000"
    sha256 ventura:        "ac4479fa581e6e4932350745653cf9d392bdc2f8fc6ae7f8a6af2639d219a0b4"
    sha256 monterey:       "52441c0417872be911d39cf718c7937b752548a918429391b0e26d38b66af3fc"
    sha256 big_sur:        "fc9cc0c2b3f3f7ebc9156d3e0c57e46b525a622c316678634ac3ca7602a3d33a"
    sha256 x86_64_linux:   "5562f9355239c29ae8471b50574c911782e2de2554db163f75c75893d1ad55ef"
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
