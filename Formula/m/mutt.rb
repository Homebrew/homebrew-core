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
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-2.2.14.tar.gz"
  sha256 "d162fb6d491e3af43d6f62f949b7e687bb0c7c2584da52c99a99354a25de14ef"
  license "GPL-2.0-or-later"
  revision 1

  # Livecheck uses GitLab tags to determine current version.
  # They all have `-rel` suffix which needs to be omitted.
  #
  # BitBucket strategy doesn't work for some reason.
  livecheck do
    url "https://gitlab.com/muttmua/mutt.git"
    regex(/^mutt[._-]v?(\d+(?:-\d+)+)-rel$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1a873051960df2b490cbeefc0e8f01ef20db4ca770684bc078f29b04dac8d8b4"
    sha256 arm64_sequoia: "ad1666b7a72c6ebc86c3ebe83ffdea86e58b72a9cda954531fee16fc01116c3e"
    sha256 arm64_sonoma:  "9643a80c2b69b3bd3ced5b7dd6b11d4a93cf0c8e7ec4ab10194dade10792c968"
    sha256 arm64_ventura: "8e52fb4d5a97894d9309c15f0be00c09b3480dca379b902186f1c54562761fb2"
    sha256 sonoma:        "90f3cb0b88dd3687353c82114aad68fc43bc45fa4151398169479f5313f5bbe1"
    sha256 ventura:       "3d7c6220370ad7283c98849a86f60585c64f3a25bbfd31537820916b6d53abdf"
    sha256 arm64_linux:   "2df5f68439d230d72b8368b98d9a29693bd584f72e4c1997a2d821fe482265fe"
    sha256 x86_64_linux:  "3383f34c489cc5e71986a18b8686359110108ed5cacd16fd59895c41431f9e28"
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
