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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-1.11.2.tar.gz"
  sha256 "da5cd4c39f228914d3933d8cf3a017c8271fdd9b9d81c6e4fc42ad22e1a28723"

  bottle do
    sha256 "fbbfffe3341a5b0ab81a52275f675b27587024c1f72b998ebed8dbaf41b515ec" => :mojave
    sha256 "1eb123e659cb6515bb933c51d4a95705f3e9a9f21eac9b681cfb13af95bd2653" => :high_sierra
    sha256 "492f164d98be2b2c32a762bebc5a12214e2aebb375ae1435a06328bda19fdbe8" => :sierra
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git"

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "gpgme" => :optional

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
    ]

    args << "--enable-gpgme" if build.with? "gpgme"

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
