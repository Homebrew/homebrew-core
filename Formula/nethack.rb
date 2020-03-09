# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.6/nethack-366-src.tgz"
  version "3.6.6"
  sha256 "cfde0c3ab6dd7c22ae82e1e5a59ab80152304eb23fb06e3129439271e5643ed2"
  head "https://github.com/NetHack/NetHack.git"

  bottle do
    rebuild 1
    sha256 "32ce4c30778ee034641e0659aa351b1d8db9ac41fd6bc10bf3de590d600b57ca" => :catalina
    sha256 "a987ad9df89f765d3d2b8451c4cfbdd6728e64b3fb239d5b2af6da76a706460b" => :mojave
    sha256 "4ee79f011195859ee87569c6d7080d438d9e7d23e4a096a437187da8479cc126" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    # Fixes https://github.com/NetHack/NetHack/issues/274
    ENV.O0

    cd "sys/unix" do
      if MacOS.version >= :mojave
        hintfile = "macosx10.14"
      else
        hintfile = "macosx10.10"
      end

      # Enable wizard mode for all users
      inreplace "sysconf", /^WIZARDS=.*/, "WIZARDS=*"

      # Enable curses interface
      # Setting VAR_PLAYGROUND preserves saves across upgrades
      inreplace "hints/#{hintfile}" do |s|
        s.change_make_var! "HACKDIR", libexec
        s.change_make_var! "CHOWN", "true"
        s.change_make_var! "CHGRP", "true"
        s.gsub! "#WANT_WIN_CURSES=1", "WANT_WIN_CURSES=1\nCFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/nethack\"'"
      end

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    system "make", "install"
    bin.install_symlink libexec/"nethack"
    man6.install "doc/nethack.6"
  end

  def post_install
    # These need to exist (even if empty) otherwise nethack won't start
    savedir = HOMEBREW_PREFIX/"share/nethack"
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
    system "#{bin}/nethack", "-s"
    assert_match (HOMEBREW_PREFIX/"share/nethack").to_s,
                 shell_output("#{bin}/nethack --showpaths")
  end
end
