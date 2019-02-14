# Note: Mutt has a large number of non-upstream patches available for
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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-1.11.3.tar.gz"
  sha256 "a542f4c02faecd171b4215ddbd368910faee4a634cca7aea5337586118ab1941"

  bottle do
    sha256 "0d81b59a5d679762f93de2a02d9e3256228a5c07fe0f76bb01b66599e4c5032c" => :mojave
    sha256 "57ad5a0eb6e0b8757c59b4c80305d88196340782e51ce5727554766febe91817" => :high_sierra
    sha256 "453a9ff522a957e89b7d816766827b6fa4584c41811d191558b43829e962155d" => :sierra
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git"

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gpgme"
  depends_on "openssl"
  depends_on "tokyo-cabinet"

  conflicts_with "tin",
    :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    user_in_mail_group = Etc.getgrnam("mail").mem.include?(ENV["USER"])
    effective_group = Etc.getgrgid(Process.egid).name

    args = %W[
      --disable-dependency-tracking
      --disable-warnings
      --prefix=#{prefix}
      --enable-debug
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-sasl
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --with-tokyocabinet
      --enable-gpgme
    ]

    system "./prepare", *args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    unless user_in_mail_group
      inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = #{effective_group}"
    end

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  def caveats; <<~EOS
    mutt_dotlock(1) has been installed, but does not have the permissions lock
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
