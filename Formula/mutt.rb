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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-2.2.9.tar.gz"
  sha256 "fa531b231d58fe1f30ceda0ed626683ea9ebdfb76ce47ef8bb27c2f77422cffb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "5fa6f5259600067cd92062db1b39eab0ead4d3948cf8d75632a71aea39dab1ee"
    sha256 arm64_monterey: "7581dde4cd1e5a1d212a4717501fe1aa583da29e73311a2ba99e7345bd30c074"
    sha256 arm64_big_sur:  "e8d25146c9af852f3a42e67ad5f2f4220a602c03e2d4473d04b742422d6cc4d3"
    sha256 ventura:        "4ad6d9e2cacf4ae7b55ea8d8aaffa4c408249d55fe6ca2e95512e964012c1233"
    sha256 monterey:       "aa5fd22d5e6cc922b8ce772da71f0983cdc0970dac08755e32a8a55afbc0fa4f"
    sha256 big_sur:        "dea8564bdac672468fc03e7f56bf763efcf6b6b8449edcd927dea5e34f3c2343"
    sha256 catalina:       "2c58602698841548996bec5ce6e5e4eb03b829e870706273f889fb0c00b90b0d"
    sha256 x86_64_linux:   "64c5c039490d0c9c4524c429b230df0cd42301ae6a5abf407d9b8b44049743e3"
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
  depends_on "openssl@1.1"
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
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-sasl
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-tokyocabinet
      --enable-gpgme
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
