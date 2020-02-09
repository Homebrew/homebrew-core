# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://nethack.org/download/3.6.5/nethack-365-src.tgz"
  version "3.6.5"
  sha256 "bb6aef2b7a4cf9463c5c4b506b80645379125c0f8de57ad7acd639872fd22e76"
  head "https://github.com/NetHack/NetHack.git"

  bottle do
    sha256 "c2a610788486d8bc25708ad37ccc133fbb1d43f30a1f08c15f989be691a872d2" => :catalina
    sha256 "d3dd937be7a736b64c8f793aae2ac76e77d4e8cf60886a6decf06dd627d8ff19" => :mojave
    sha256 "837b7979cf18f3d94ebc518bc14f6c8027bf87540910d778d62fc02a67255ba8" => :high_sierra
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
