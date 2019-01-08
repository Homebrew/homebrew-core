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
    sha256 "705b2fe166b1e76823531ba4c65af1284610d62b9e6c22eec6703044fcc9e13e" => :mojave
    sha256 "a1439cdf8cd81744792d80e4747b9103f67fa0ec7565be9b74425ff3ddd213f1" => :high_sierra
    sha256 "c49aeb0838993a63be25ae6031ab2a34176c64dde6d37a6dc484e5d34b861457" => :sierra
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
