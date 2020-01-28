# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://nethack.org/download/3.6.5/nethack-365-src.tgz"
  version "3.6.5"
  sha256 "bb6aef2b7a4cf9463c5c4b506b80645379125c0f8de57ad7acd639872fd22e76"
  head "https://github.com/NetHack/NetHack.git"

  bottle do
    sha256 "c4866c1b5490225f7ab95836dbb5e94f0c2c715cc6be450ddd259a9f40ac1ba0" => :catalina
    sha256 "9acfbe2f46d6a495956e8eefb6bee683ffdd1150ad5ba2b2adfe790dd247dbe3" => :mojave
    sha256 "cbc9e757a52af2f2dbead1bb0e851376a879c721e756f94abec6660f1346f096" => :high_sierra
  end

  uses_from_macos "ncurses"

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order
    ENV.deparallelize

    # Disable optimization since it causes a hang in the / command
    # See issue #48465
    ENV.O0

    # Generate makefiles for OS X
    cd "sys/unix" do
      if MacOS.version >= :mojave
        hintfile = "macosx10.14"
      else
        hintfile = "macosx10.10"
      end

      # Enable wizard mode for all users
      inreplace "sysconf", /^WIZARDS=.*/, "WIZARDS=*"

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    # Make the game with curses
    system "make", "install", "HACKDIR=#{libexec}", "WANT_WIN_CURSES=1"
    bin.install "src/nethack"
    (libexec+"save").mkpath

    # Enable `man nethack`
    man6.install "doc/nethack.6"

    # These need to be group-writable in multi-user situations
    chmod "g+w", libexec
    chmod "g+w", libexec+"save"
  end

  test do
    system "#{bin}/nethack", "-s"
  end
end
