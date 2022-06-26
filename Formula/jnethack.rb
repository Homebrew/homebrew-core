# NetHack the way God intended it to be played: from a terminal.
# This formula is based on the NetHack formula.

class Jnethack < Formula
  desc "Japanese localization of NetHack"
  homepage "https://jnethack.osdn.jp/"
  # We use a git checkout to avoid patching the upstream NetHack tarball.
  url "https://scm.osdn.net/gitroot/jnethack/source.git",
      tag:      "v3.6.6-0.5",
      revision: "b73f026674d524b563794826884c141ae8217dea"
  license "NGPL"
  head "https://github.com/jnethack/jnethack-alpha.git", branch: "develop"

  bottle do
    sha256 arm64_monterey: "4c59235ec6822463a71c1d9b422e01275ec47f5e7f7e31985f34946b2faa67a4"
    sha256 arm64_big_sur:  "2c689f7800cbb1e8871c61a9942a8509e9948a7915b6602b3079dddd70cec2f3"
    sha256 monterey:       "262dfe4f07fb46856aab7d687de50e0b06865205ca9441b8e1c2e3fe3d1cd1d3"
    sha256 big_sur:        "992e84d15108722136983844bd6a34cb7f5463e5bd697b32ac7659419f5bc21b"
    sha256 catalina:       "f59a9c1dc29af967186ad412078b7fde04b2ff21701c920f97a21ac63ef14524"
    sha256 x86_64_linux:   "e8c746c0df2deb305dfcbd6427281d2d0f69cf9a011e05e29ce97403352c74ee"
  end

  depends_on "nkf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize
    ENV.O0

    # Enable wizard mode for all users
    inreplace "sys/unix/sysconf", /^WIZARDS=.*/, "WIZARDS=*"

    platform = OS.mac? ? "macosx10.10" : OS.kernel_name.downcase

    # Only this file is touched by jNetHack, so don't switch on macOS versions
    inreplace "sys/unix/hints/#{platform}" do |s|
      # macOS clang doesn't support code page 932
      s.gsub! "-fexec-charset=cp932", "" if OS.mac?
      s.change_make_var! "HACKDIR", libexec
      s.change_make_var! "CHOWN", "true"
      s.change_make_var! "CHGRP", "true"
      # Setting VAR_PLAYGROUND preserves saves across upgrades. With a bit of
      # work this could share leaderboards with English NetHack, however bones
      # and save files are much tricker. We could set those separately but
      # it's probably not worth the extra trouble. New curses backend is not
      # supported by jNetHack.
      replace_string = OS.mac? ? "#WANT_WIN_CURSES=1" : "#CFLAGS+=-DEXTRA_SANITY_CHECKS"
      s.gsub! replace_string, "CFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/jnethack\"'"
    end

    # We use the Linux version due to code page 932 issues, but point the
    # hints file to macOS
    inreplace "japanese/set_lnx.sh", "linux", "macosx10.10" if OS.mac?
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
