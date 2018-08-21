# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.1/nethack-361-src.tgz"
  version "3.6.1"
  sha256 "4b8cbf1cc3ad9f6b9bae892d44a9c63106d44782a210906162a7c3be65040ab6"
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.1"

  bottle do
    sha256 "a6edc4d29cc966b69a6ebc87048d4a27475465a9c1a251908edf45718da02ef5" => :mojave
    sha256 "a57fbc5bdea2350dc989315ca1366da7778496421fd1962ceca266897754b2cf" => :high_sierra
    sha256 "57db6043731411211c6de280e66c98394f0b13db000f26749afb243bf0211289" => :sierra
    sha256 "fe8264cd2c58b19c58b4192f1eb74fe8e44f503885a300ef1cba71c402abe4d3" => :el_capitan
  end

  # Don't remove save folder
  skip_clean "libexec/save"

  def install
    # Build everything in-order
    ENV.deparallelize

    # Generate makefiles for OS X
    cd "sys/unix" do
      if MacOS.version >= :yosemite
        hintfile = "macosx10.10"
      elsif MacOS.version >= :lion
        hintfile = "macosx10.7"
      else
        hintfile = "macosx10.5"
      end

      inreplace "hints/#{hintfile}",
                /^HACKDIR=.*/,
                "HACKDIR=#{libexec}"

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    # Enable wizard mode for all users
    inreplace "sys/unix/sysconf",
      /^WIZARDS=.*/,
      "WIZARDS=*"

    # Make the game
    system "make", "install"
    bin.install "src/nethack"
    (libexec+"save").mkpath

    # Enable `man nethack`
    man6.install "doc/nethack.6"

    # These need to be group-writable in multi-user situations
    chmod "g+w", libexec
    chmod "g+w", libexec+"save"
  end
end
