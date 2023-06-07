# NetHack the way God intended it to be played: from a terminal.
# This formula is based on the NetHack formula.

class Jnethack < Formula
  desc "Japanese localization of NetHack"
  homepage "https://jnethack.osdn.jp/"
  # We use a git checkout to avoid patching the upstream NetHack tarball.
  url "https://scm.osdn.net/gitroot/jnethack/source.git",
      tag:      "v3.6.6-0.6",
      revision: "1fe57469d3f3bc20997f5f219c33bf4973a41b82"
  license "NGPL"
  head "https://github.com/jnethack/jnethack-alpha.git", branch: "develop"

  bottle do
    sha256 arm64_ventura:  "bbe1c0eb7582de509ecb7c93b4ba51ada47037ed587f683acaf96733bde9760e"
    sha256 arm64_monterey: "2265c4c5dca76edc0c3672b3746f75d1cbeab782b4ef86463ab8848b312673d5"
    sha256 arm64_big_sur:  "48982dc5af4eaa7ebd63ef444f842ef9c6f765f8d6e0961b15169f6e457206a1"
    sha256 ventura:        "0810b061a4a0f4383b5e0d6efd2b4559003d6e29b3f3e8cb3cb348132a41afbb"
    sha256 monterey:       "a52cfa300594235e2eb059b600d4d752fa2d444793df11efff657ef0d142c9e0"
    sha256 big_sur:        "d549f80aa1df93f3ebdfdd51e0ddbb2924fb812b76fb2659089403c942f59ec5"
    sha256 catalina:       "3a2629567e689e94a69a3cf813ae6b4e9619dd1737b0ca7336a0732eca87887a"
    sha256 x86_64_linux:   "5bb2c49b8456a359624524768f73fe67e7461bc19e4b4d70d1e0bdf68a286b4c"
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
