class Angband < Formula
  desc "Dungeon exploration game"
  homepage "http://rephial.org/"
  url "http://rephial.org/downloads/4.1/angband-4.1.1.tar.gz"
  sha256 "3fd19b109acfbf75a1a4b40eb0110c267ed1d0cc80f6edfb2f377d68add9853f"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "d853174056f21f1630c32d4b85ea909a98c9143159e178ab69475e1dbe251ef9" => :high_sierra
    sha256 "7c0676e8d460d622f7f228867ac0b20f0544a44d6556cfc7d91cda29def9022c" => :sierra
    sha256 "e6fa999cbf78e4c059f892423fb4713e885a3362f0b4ad03c3575a28e9fe7e73" => :el_capitan
  end

  option "with-cocoa", "Install Cocoa app"

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

    if build.with? "cocoa"
      cd "src" do
        system "make", "-f", "Makefile.osx"
      end
      prefix.install "Angband.app"
    end
  end

  test do
    system bin/"angband", "--help"
  end
end
