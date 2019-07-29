class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.5.tgz"
  sha256 "3e895a0a6d7bd79de25a255a1376d4da88eb09c34efdd0476ab5a907e75bfaf8"
  revision 1
  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    sha256 "f328421637732811f7c15d5a8c7d33cc9bdf415a95cb795197914287a539001b" => :mojave
    sha256 "876b72e65eda11adf593340ca26d71cf8df798e0673ab2a1c5cd3451bef90e6a" => :high_sierra
    sha256 "e72f17a2e9cd1a77330984b9037e9feba6abd3fd4d45a041b93a0e81a3439a81" => :sierra
  end

  depends_on "gettext"
  depends_on "openssl"

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
