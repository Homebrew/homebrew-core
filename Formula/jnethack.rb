# NetHack the way God intended it to be played: from a terminal.
# This formula is based on the NetHack formula.

class Jnethack < Formula
  desc "Japanese localization of NetHack"
  homepage "https://jnethack.osdn.jp/"
  # We use a git checkout to avoid patching the upstream NetHack tarball.
  url "https://scm.osdn.net/gitroot/jnethack/source.git",
    tag:      "v3.6.6-0.1",
    revision: "0ffd620440b5b61e21b40bf32e148d20c0c8349f"
  version "3.6.6-0.1"
  license "NGPL"
  head "https://github.com/jnethack/jnethack-alpha"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "22c77a0b903452c595e324b04dc5cf09d37fa56af922fc438e8aad3e4899082d" => :catalina
    sha256 "54890df9ae6c932ed1ec36deb7892e5ddd28857e3740dd0c36f9d20f231caf3d" => :mojave
    sha256 "7422717258f234810d99d330df0a0e99b90da7328db9324a92d39a63869e008b" => :high_sierra
    sha256 "89c2fed343614d39084a8c59908032fe929e78c1572e92f50b9eafa4aca3860d" => :sierra
    sha256 "c11837932635f89762360ad449e189c44e8213cb74f981ccb7908671a0e3ad4b" => :el_capitan
    sha256 "f0c7c0c5bbf5c7d5b2d733fd76d49f31039b15c982a7ef7530444f734a41ec7c" => :yosemite
  end

  depends_on "nkf" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize
    ENV.O0

    # Enable wizard mode for all users
    inreplace "sys/unix/sysconf", /^WIZARDS=.*/, "WIZARDS=*"

    # Only this file is touched by jNetHack, so don't switch on macOS versions
    inreplace "sys/unix/hints/macosx10.10" do |s|
      # macOS clang doesn't support code page 932
      s.gsub! "-fexec-charset=cp932", ""
      s.change_make_var! "HACKDIR", libexec
      s.change_make_var! "CHOWN", "true"
      s.change_make_var! "CHGRP", "true"
      # Setting VAR_PLAYGROUND preserves saves across upgrades. With a bit of
      # work this could share leaderboards with English NetHack, however bones
      # and save files are much tricker. We could set those separately but
      # it's probably not worth the extra trouble. New curses backend is not
      # supported by jNetHack.
      s.gsub! "#WANT_WIN_CURSES=1", "CFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/jnethack\"'"
    end

    # We use the Linux version due to code page 932 issues, but point the
    # hints file to macOS
    inreplace "japanese/set_lnx.sh", "linux", "macosx10.10"
    system "sh", "japanese/set_lnx.sh"
    system "make", "install"
    bin.install_symlink libexec/"jnethack"
  end

  def post_install
    # These need to exist (even if empty) otherwise NetHack won't start
    savedir = HOMEBREW_PREFIX/"share/jnethack"
    mkdir_p savedir
    cd savedir do
      %w[xlogfile logfile perm record].each do |f|
        touch f
      end
      mkdir_p "save"
      touch "save/.keepme" # preserve on `brew cleanup`
    end
    # Set group-writeable for multiuser installs
    chmod "g+w", savedir
    chmod "g+w", savedir/"save"
  end

  test do
    system "#{bin}/jnethack", "-s"
    assert_match (HOMEBREW_PREFIX/"share/jnethack").to_s,
      shell_output("#{bin}/jnethack --showpaths")
  end
end
