class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.5.tgz"
  sha256 "3e895a0a6d7bd79de25a255a1376d4da88eb09c34efdd0476ab5a907e75bfaf8"
  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    sha256 "3f625be44bdc094c374ba25d0f0ecd8c209b96f40e00eac874929edfe71a94c7" => :mojave
    sha256 "99b687e9e7cbadbb3e1774e89538395e7630152631fa90471d6f784927759c4c" => :high_sierra
    sha256 "b209aa24927ed620ce6a7e676c7358ca94d17ec456c8b7b49b72b1aec57c44ed" => :sierra
    sha256 "f283d8cde06988fa6117d7cb1e008ae480851e8f4e9ba60fd8f429864499f983" => :el_capitan
    sha256 "c4784fc08f239a6fd0f778657fe11509f445ee889f6d6b305c30c533be25f35c" => :yosemite
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
