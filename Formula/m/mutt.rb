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

  bottle do
    sha256 arm64_sequoia: "e11bd2be69fee9b5c24190699cf2318559ca0cda04520ae1845a5512e0fcd843"
    sha256 arm64_sonoma:  "b5ef0c774e2c1926a13345f73f2f6370aa28d54bd4dfff553f945fb7f9ab7858"
    sha256 arm64_ventura: "da5fc14cf6e06faab09da46efbea32504378573518a19f58645809f80d2e7781"
    sha256 sonoma:        "a2b125aa772f366ed34ee8da0d71565e88334f0dadc37c10513f358fc0c4d106"
    sha256 ventura:       "a17770bc4c28b5f01f213145fc6f78967616b8dd4b4b95839935981d9f00b058"
    sha256 arm64_linux:   "9ba607d24fa2463909af8d212233024e9c3c7fde6868bc8a2ea3c901d68d9e18"
    sha256 x86_64_linux:  "17374083e28fb5d5bad686eb2c301a0f37bf49e46c8bcd30c5a04cc90c8c79ee"
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
