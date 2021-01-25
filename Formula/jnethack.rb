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
  head "https://github.com/jnethack/jnethack-alpha.git", branch: "develop"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "9f9ffb883c96a2341c2ea098c941035f39ac428413bf0dd93c29d0a1192dce1e" => :big_sur
    sha256 "799f0a8342d6a2d05932365d09634e64abaaea6fc1ee6e7f834c7c49bda72d9d" => :arm64_big_sur
    sha256 "059b8ffd6b13d6335e746b70ac59706b632982eff307a2c9d66c1e4114bab994" => :catalina
    sha256 "6f985e89658c5c5e4443a2fa88dafef23bbad24c01ea9dbc29661eb3b1028133" => :mojave
    sha256 "34845f6e7a2773374e778043b0ca456f23aeff7f1fd72389a551a6bbe160d871" => :high_sierra
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
