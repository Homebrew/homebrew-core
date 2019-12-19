# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.4/nethack-364-src.tgz"
  version "3.6.4"
  sha256 "0531ab8466032611d61f702cb71fb3ceca78a7a4918885c1b4f2f17cb57dbd59"
  head "https://github.com/NetHack/NetHack.git"

  bottle do
    sha256 "f22b563c9e8aea4616d57f9227eb1974e4160747dd2cb229f4e3528daabf346d" => :catalina
    sha256 "245aa0e0e81b8a57456ab2143adc61d4d939a3aa56ae651b89476c459d28f9dc" => :mojave
    sha256 "de56066a50b1fcfc2f39d5084c5f9e08118768bbbb8aeb3d0c4696d042c10466" => :high_sierra
  end

  uses_from_macos "ncurses"

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order
    ENV.deparallelize

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
