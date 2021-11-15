# NetHack the way God intended it to be played: from a terminal.
# This formula is based on the NetHack formula.

class Jnethack < Formula
  desc "Japanese localization of NetHack"
  homepage "https://jnethack.osdn.jp/"
  # We use a git checkout to avoid patching the upstream NetHack tarball.
  url "https://scm.osdn.net/gitroot/jnethack/source.git",
      tag:      "v3.6.6-0.3",
      revision: "b540f584f32fa4257d793526126f8a002d632913"
  license "NGPL"
  head "https://github.com/jnethack/jnethack-alpha.git", branch: "develop"

  bottle do
    sha256 arm64_monterey: "8569022fe0800eaebd2c15f46e3622bb1c312930f5ab9c39f451999f61b3bf33"
    sha256 arm64_big_sur:  "543cc702bdbcec370efb5f8820ffdec835c4d5628f320a065b03cccaefbc7672"
    sha256 monterey:       "ce939c6db0802b89a09fb4e85c9a76abda8a1bbfd063a18c755756dd384e14de"
    sha256 big_sur:        "468df05f39f3567eeb4c4eecf1faa98f0ce316df637178eea466293b5595d3d9"
    sha256 catalina:       "324892f392e85b73180a2ac0790d2235e5a328051e82f7b07b3e62eef98a4a72"
    sha256 mojave:         "95030dd28a07b2a099878a47758bdee17f2ea855333269b428f35fe3a0f4361f"
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
