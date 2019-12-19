# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.4/nethack-364-src.tgz"
  version "3.6.4"
  sha256 "0531ab8466032611d61f702cb71fb3ceca78a7a4918885c1b4f2f17cb57dbd59"
  head "https://github.com/NetHack/NetHack.git"

  bottle do
    sha256 "97681ae93eebecc753330c8337bccfac8485927bd4a59d091e3afe41e2575674" => :catalina
    sha256 "f0cc750101ae9d758655a1662b313edc29c5ffc3118f5c925dc4a35885b591a9" => :mojave
    sha256 "338ec64c471bc1992bcf768052af2d0383a5fc053426d34281c74b8ff0ec7f4b" => :high_sierra
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
