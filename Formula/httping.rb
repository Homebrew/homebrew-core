class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.5.tgz"
  sha256 "3e895a0a6d7bd79de25a255a1376d4da88eb09c34efdd0476ab5a907e75bfaf8"
  revision 2
  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    sha256 "2314efd3b919b759290b7ead8dea99c50b11860f7aadb8fd4f9c7e0e7cc92e5e" => :mojave
    sha256 "8df0f98d479c72a20ca2b353a06c9c1bf071cceed53774c737f41caf27238fc1" => :high_sierra
    sha256 "9d0b6368e6fa4e2b4fb618c7ba3893a5b3b47471b366305026ee75b44d6ce91e" => :sierra
  end

  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w[configure Makefile], "ncursesw", "ncurses"
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    if MacOS.version >= :el_capitan
      system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
    else
      system bin/"httping", "-c", "2", "-g", "http://brew.sh/"
    end
  end
end
