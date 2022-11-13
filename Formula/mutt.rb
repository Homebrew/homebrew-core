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
    sha256 arm64_ventura:  "1c30b4ebe19e84537883e792ad817893987ec7e8ebf953d41e36460b21169dfe"
    sha256 arm64_monterey: "8f53cf6551dfa7de353334e82871eb8f1a7b30e7afb1405b805325d82aea9426"
    sha256 arm64_big_sur:  "5e1bf64d66ef9710bd8035559185a8d6796a4f42f1675997449ca0d39dc909bc"
    sha256 monterey:       "85fa27398f94598b07b40ce123fb494578bebdd9671f435d6822034651857e07"
    sha256 big_sur:        "4ae0af9f2563ace7c1ead3461c21ffaf077f50f4cc344d51e2715fd5263845de"
    sha256 catalina:       "bc7e57d5404fa9505ea25e4b4b38a21360304c3faf24bdce5bd6ee13e7e48d6d"
    sha256 x86_64_linux:   "bea1d8d1990965ba5d0382ade82aaac566bfe266b9a718047eaff5ce7dac66a3"
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
