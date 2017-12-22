class Angband < Formula
  desc "Dungeon exploration game"
  homepage "http://rephial.org/"
  url "http://rephial.org/downloads/4.1/angband-4.1.2.tar.gz"
  sha256 "30bc0979e0845cdc43de2a8f65c4d54d03d24d402b32b8589fbbc368ccfa0e2a"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "1a601dc2d55ebb76c448068c0e324bded5e9791ca0f9775489cee44985a47cbf" => :high_sierra
    sha256 "a1f526b26f8acf8600eca8ef6299fc8920d42cb00c268e1b9e7d68b3d857fdd6" => :sierra
    sha256 "332680a711469ba08246a73bfdea5e82ddac47cad0db0cd9dfedc4c93dfcd3ed" => :el_capitan
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
