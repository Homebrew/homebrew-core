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
  url "https://gitlab.com/muttmua/mutt/-/archive/mutt-2-2-15-rel/mutt-mutt-2-2-15-rel.tar.gz"
  version "2.2.15"
  sha256 "3c931dd65993d2e63a3dcd6bbf1fd88c033ae0f6e377c5d4f88b14fe9170817d"
  license "GPL-2.0-or-later"

  # Livecheck uses GitLab tags to determine current version.
  # They all have `-rel` suffix which needs to be omitted.
  livecheck do
    url "https://gitlab.com/muttmua/mutt.git"
    regex(/^mutt[._-]v?(\d+(?:-\d+)+)-rel$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "75669d6239c44d5f13c52565e1c4b19f36b2e552f3b853c9ac98813437a8e181"
    sha256 arm64_sequoia: "4e9df72dad1e0e9629c46428b23aead3bed33732340a94df9b80d503035089b8"
    sha256 arm64_sonoma:  "c760d241f11a8ecda970ac6710eae57fd21e0ee6fbf7d2403bb383a2507d30b4"
    sha256 sonoma:        "d4252e6a4f29d2ed772b2e6cb35443050233172162a184d1b020ccbee53dfed3"
    sha256 arm64_linux:   "256483eb0551b850f40b2c42f9c7e36846e521492b88ae15243a6b51cd9cb9a9"
    sha256 x86_64_linux:  "250d93e09deab42ad9b07ab66db482f8f482b6f22e46518382e101148a6e706f"
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
  depends_on "libgpg-error"
  depends_on "libidn2"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "tokyo-cabinet"

  uses_from_macos "bzip2"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  conflicts_with "tin", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    user_in_mail_group = Etc.getgrnam("mail").mem.include?(ENV["USER"])
    effective_group = Etc.getgrgid(Process.egid).name

    args = %W[
      --disable-warnings
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

    system "./prepare", *args, *std_configure_args
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
