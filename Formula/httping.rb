class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.4.tgz"
  sha256 "dab59f02b08bfbbc978c005bb16d2db6fe21e1fc841fde96af3d497ddfc82084"
  revision 1

  revision 1

  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    sha256 "bee4a915ecb4ebc8b74ae05c3b51b95f94629f75ea30e4df255392904f98380c" => :el_capitan
    sha256 "06236c9892c91124bbc3d6942a9741564eb9c0e49f3c972efe00bc55cf56bf10" => :yosemite
    sha256 "1386f523b728db68133283449e7ea5476c842056e168440437b87039decfea22" => :mavericks
  end

  depends_on "gettext"
  depends_on "openssl"
  depends_on "fftw" => :optional

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w[configure Makefile], "ncursesw", "ncurses"
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "http://brew.sh"
  end
end
