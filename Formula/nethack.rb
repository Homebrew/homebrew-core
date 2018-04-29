# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.1/nethack-361-src.tgz"
  version "3.6.1"
  sha256 "4b8cbf1cc3ad9f6b9bae892d44a9c63106d44782a210906162a7c3be65040ab6"
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.1"

  bottle do
    sha256 "3a87d95f55694f603ef141893be865db0762c2244a40072034314b0aa6bc6ebb" => :high_sierra
    sha256 "31ba131716f9e1deb6d4facca23855823ea916dc8d0edc6c4a50bcc744684936" => :sierra
    sha256 "1fc48d05f9ca71d73292c03b8860a22ca6c8a35f09b92f700918ae4290a73ecf" => :el_capitan
    sha256 "c15f61fb6867b3a68dbb4f68d09e787afda6e6f2498123bb9972547803a0a19e" => :yosemite
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
