class Cgterm < Formula
  desc "Color graphics telnet client for connecting to Commodore 64 BBSes"
  homepage "https://paradroid.automac.se/cgterm/"
  url "https://paradroid.automac.se/cgterm/cgterm-1.6.tar.gz"
  sha256 "21b17a1f5178517c935b996d6f492dba9fca6a88bb7964f85cce8913f379a2a1"

  depends_on "sdl"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Note that '-h' option is broken and returns 1 but should print usage
    assert_match "cgterm [-4|-8] [-d delay] [-f] [-k keyboard.kbd] [-o logfile] [-r seconds]",
      shell_output("#{bin}/cgterm -h 2>&1", 1)
  end
end
