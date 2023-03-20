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
    rebuild 1
    sha256 arm64_ventura:  "75402fa2874ea11b9161df5a1570d5d37a17a5b139ff963f050c724311e472f8"
    sha256 arm64_monterey: "f278aee880d1f861f8b4bffa4a505ad37c007edc809ea4b31641a7978c2f2b85"
    sha256 arm64_big_sur:  "b6add7e90b217df2a3bbb346182e6fb1b409bbff4619c741a3c0f08aa903d725"
    sha256 ventura:        "7bb9f3303700a0c0d89c76a85defe9290ac60cfd63e89cbf38070e7531c1d3be"
    sha256 monterey:       "d15f5bea037b83f62f4d7cf858cefd33345b97e9e8450fbe79f0d4849cae9ca2"
    sha256 big_sur:        "54e8a82b62d333bb241fc4d3f212f09cff0d3ede07dca280a38e77e788b67afc"
    sha256 x86_64_linux:   "4aa24d8649a336ef29f04e08ae3b5aad77edd63668004985c8a5aa728aedb7de"
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
      --enable-gpgme
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-idn2
      --with-sasl
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
