# NetHack the way God intended it to be played: from a terminal.
# This formula is based on the NetHack formula.

class Jnethack < Formula
  desc "Japanese localization of NetHack"
  homepage "https://jnethack.osdn.jp/"
  # We use a git checkout to avoid patching the upstream NetHack tarball.
  url "https://scm.osdn.net/gitroot/jnethack/source.git",
      tag:      "v3.6.6-0.2",
      revision: "1dff0026832d47d3c93ff263afad233cced3a387"
  version "3.6.6-0.2"
  license "NGPL"
  head "https://github.com/jnethack/jnethack-alpha.git", branch: "develop"

  bottle do
    sha256 arm64_big_sur: "e47fb14c7fe6a0d6beb2ed26c0ff638a9ed01923ff52f128ae87403096f0e0c6"
    sha256 big_sur:       "133ff48b209c6d3a4552a503bc494bec664757374047db3764998e4662e9aaef"
    sha256 catalina:      "12fd8e36187747ecc39f95d51db36903890a57d21c04e46fee201b1d6d464331"
    sha256 mojave:        "f142fc64a2a42b4b6d42a14b9c8afbdaa70c65d22e0a0bc3e8d2c63b503aeab0"
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
