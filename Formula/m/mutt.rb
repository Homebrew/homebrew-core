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
  url "http://ftp.mutt.org/pub/mutt/mutt-2.2.16.tar.gz"
  sha256 "1d3109a743ad8b25eef97109b2bdb465db7837d0a8d211cd388be1b6faac3f32"
  license "GPL-2.0-or-later"

  # Livecheck uses GitLab tags to determine current version.
  # They all have `-rel` suffix which needs to be omitted.
  livecheck do
    url "https://gitlab.com/muttmua/mutt.git"
    regex(/^mutt[._-]v?(\d+(?:-\d+)+)-rel$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "06ea8391b928c80af89ebd9a2a2a7453c68a96f2354caf3339897ea53675c0f1"
    sha256 arm64_sequoia: "de913ddba41e3f6a1d0819a62bf65945dc3025869565e42358de41a0ce5d61df"
    sha256 arm64_sonoma:  "10ef4e94a3371d85349b09d1131bc3bf995f0bb72a32c2c1b2da129aa6935991"
    sha256 sonoma:        "3e41590dfed3a0e80fbd5edbb741912a6f9d9da22d78378a727af2108da52cb1"
    sha256 arm64_linux:   "44ae949e70e0fd867ac5a36d26dedeaee7e0c867feaff1cd2978d82d348853dd"
    sha256 x86_64_linux:  "363d6627599998ada6b02599e4e8587fa35e66c8c9fc3df9a40885b19ce4939d"
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

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

    configure = build.head? ? "./prepare" : "./configure"
    system configure, *args, *std_configure_args
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
