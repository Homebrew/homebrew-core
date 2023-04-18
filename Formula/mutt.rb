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

  bottle do
    sha256 arm64_ventura:  "2d57c5e98a83b23e613e4871845182047ec32a46fbd9847ea50de33631b42f95"
    sha256 arm64_monterey: "8d1cc8bba3bccfcc430446b4dedefdf76867aafb78fb5f7849d43bb4231fd89d"
    sha256 arm64_big_sur:  "de0c21972cb6d4b83ff817a44591b5d5c170f3d397c3c94d983bfd6a10ad3328"
    sha256 ventura:        "14e95a2c9d663cef182df117a0fb97e06c970b9704f4889a852e7f404a26e613"
    sha256 monterey:       "5108f22bcb31232a43ecef02a277a8ccaa7f9ceb09f26563eaa7aac2402dbb4a"
    sha256 big_sur:        "8d12a3966163a54102298a45dcb6b36ab9d35197a969c9c92330f9eb4653fc46"
    sha256 x86_64_linux:   "3404125e6762680bdcf3b13fbb675901d1981c6d25e15cc93efb9089121f9dc1"
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
