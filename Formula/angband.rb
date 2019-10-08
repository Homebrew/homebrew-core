class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://rephial.org/downloads/4.2/angband-4.2.0.tar.gz"
  sha256 "d3e1495c7cc2a4ee66de7b4e612d3b133048072e37504bd2e58a2351ab0fb56d"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "dc6f1a83a2810d52da345f6612064a2b851071a92a0eec5338ee6f1a933b3186" => :mojave
    sha256 "611854a1b7d74e879f596ea2a03522eb5cba323cc7db047a918d2affb60c79fd" => :high_sierra
    sha256 "6330d08684c373c901f25845b838a3ac6c8c6c5ebeae80c7d3f6a63c198af181" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--libdir=#{libexec}",
                          "--enable-curses",
                          "--disable-ncursestest",
                          "--disable-sdltest",
                          "--disable-x11",
                          "--with-ncurses-prefix=#{MacOS.sdk_path}/usr"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"angband", "--help"
  end
end
