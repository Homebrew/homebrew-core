class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.C.tar.gz"
  version "0.C"
  sha256 "69e947824626fffb505ca4ec44187ec94bba32c1e5957ba5c771b3445f958af6"

  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    revision 1
    sha256 "d971aada9f12856f4821060da28dd27c279f5c9fdbd5e5b986f0b1625bac8c8f" => :el_capitan
    sha256 "2a85ba8077717c40e87ff3534f2a16303ec9b7534de435ec5f4c8d03bb5a90a7" => :yosemite
    sha256 "48e06785a79eb82ee72d180dc88b400fd0875026f21e0bb69a03ccd0aa9bb506" => :mavericks
  end

  option "with-tiles", "Enable tileset support"

  needs :cxx11

  depends_on "gettext"
  # needs `set_escdelay`, which isn't present in system ncurses before 10.6
  depends_on "homebrew/dupes/ncurses" if MacOS.version < :snow_leopard

  if build.with? "tiles"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_ttf"
  end

  def install
    ENV.cxx11

    # cataclysm tries to #import <curses.h>, but Homebrew ncurses installs no
    # top-level headers
    ENV.append_to_cflags "-I#{Formula["ncurses"].include}/ncursesw" if MacOS.version < :snow_leopard

    args = %W[
      NATIVE=osx RELEASE=1 OSX_MIN=#{MacOS.version}
    ]

    args << "TILES=1" if build.with? "tiles"
    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    # no make install, so we have to do it ourselves
    if build.with? "tiles"
      libexec.install "cataclysm-tiles", "data", "gfx"
    else
      libexec.install "cataclysm", "data"
    end

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end
end
