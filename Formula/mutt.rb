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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-1.8.2.tar.gz"
  mirror "ftp://ftp.mutt.org/pub/mutt/mutt-1.8.2.tar.gz"
  sha256 "1d057bf1b565f2c38ee50c9a661654cbbe4165f98e25bfa361ebbd707d96f235"

  bottle do
    sha256 "544c31ce3409c499a4675a8a90d2c6ed2b08254577f5f06036df7030084c8934" => :sierra
    sha256 "74b45997a3775c3f6cf52eb8f0af511a08c8f8715c8a1a07b59cb7035195d472" => :el_capitan
    sha256 "c2b49ed8f9d43e2abe39927f8e073550f6c01705bd42ede893a21329dfab76ec" => :yosemite
  end

  head do
    url "https://dev.mutt.org/hg/mutt#default", :using => :hg

    resource "html" do
      url "https://dev.mutt.org/doc/manual.html", :using => :nounzip
    end
  end

  option "with-debug", "Build with debug option enabled"
  option "with-s-lang", "Build against slang instead of ncurses"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "gettext" => :optional
  depends_on "gpgme" => :optional
  depends_on "libidn" => :optional
  depends_on "s-lang" => :optional

  conflicts_with "tin",
    :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    user_admin = Etc.getgrnam("admin").mem.include?(ENV["USER"])

    args = %W[
      --disable-dependency-tracking
      --disable-warnings
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --with-sasl
      --with-gss
      --enable-imap
      --enable-smtp
      --enable-pop
      --enable-hcache
      --with-tokyocabinet
      --enable-sidebar
    ]

    # This is just a trick to keep 'make install' from trying
    # to chgrp the mutt_dotlock file (which we can't do if
    # we're running as an unprivileged user)
    args << "--with-homespool=.mbox" unless user_admin

    args << "--disable-nls" if build.without? "gettext"
    args << "--enable-gpgme" if build.with? "gpgme"
    args << "--with-slang" if build.with? "s-lang"

    if build.with? "debug"
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./prepare", *args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    if user_admin
      inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = admin"
    end

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  test do
    system bin/"mutt", "-D"
  end
end
