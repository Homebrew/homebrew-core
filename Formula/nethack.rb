# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.2/nethack-362-src.tgz"
  version "3.6.2"
  sha256 "fbd00ada6a4ee347ecd4a350a5b2995b4b4ab5dcc63881b3bc4485b0479ddb1d"
  revision 1
  head "https://git.code.sf.net/p/nethack/NetHack.git", :branch => "NetHack-3.6.2"

  bottle do
    sha256 "6d2a20d495af1566735b5a54a366169c20da893c15c74fe0e9a7e89bf1b3e58a" => :catalina
    sha256 "029b30c74691c4e207f0dbd0dcfb7643dfac8cfacc29d2aabaa9b3a728946c95" => :mojave
    sha256 "15b49603100056b2b81fd90eae869934aeacc197e26cf97937fbaf1d446c9ba9" => :high_sierra
    sha256 "4afdeae7f562cbcbab4d1ac7f68cd1d534a987b3521e2507bb4a81ccd44fc6bc" => :sierra
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
