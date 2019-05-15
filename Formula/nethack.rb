# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.2/nethack-362-src.tgz"
  version "3.6.2"
  sha256 "fbd00ada6a4ee347ecd4a350a5b2995b4b4ab5dcc63881b3bc4485b0479ddb1d"
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.2"

  bottle do
    sha256 "e62f6cc80fb1ffe25c7e16394058b315cbf0414c4df2f27af44d81d3f1230810" => :mojave
    sha256 "ab98815750c7bf5c38e7bbdaf2c8e55588a0c73070868b929cff096918c6f6f8" => :high_sierra
    sha256 "6ab73c6cca85d88e4a9d8fd0456f1a8bb98089c9bd9fff43f22cd0b457ab9684" => :sierra
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
      else
        hintfile = "macosx10.7"
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
