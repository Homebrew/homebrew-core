class Nxengine < Formula
  desc "Rewrite of Cave Story (Doukutsu Monogatari)"
  homepage "https://nxengine.sourceforge.io/"
  url "https://nxengine.sourceforge.io/dl/nx-src-1006.tar.bz2"
  version "1.0.0.6"
  sha256 "cf9cbf15dfdfdc9936720a714876bb1524afbd2931e3eaa4c89984a40b21ad68"

  bottle do
    sha256 "e9e11b68627fbe16f938ba6c2b0c5fd8cb5fe3c5515ea477ff7c1556a6a34b4c" => :mojave
    sha256 "32b384c1e7fdd33ecf71ccf88641096ca191402cce0c0ec4866575502ced50b3" => :high_sierra
    sha256 "6f24e86f6bf1b4a41b9938a99feafffc83469561031d16d5160543e0bf24e251" => :sierra
    sha256 "2002c715a6f1d169ac67eedef28c924392abc9f3a4620913d96992b6a0ae6e85" => :el_capitan
    sha256 "c7990df854be6f704eee378d7f149a87fdb8519ff6272711fe875be3b74e6c9c" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_ttf"

  # Freeware Cave Story 1.0.0.6 pre-patched with Aeon Genesis English translation
  resource "game" do
    url "https://www.cavestory.org/downloads/cavestoryen.zip"
    sha256 "aa87fa30bee9b4980640c7e104791354e0f1f6411ee0d45a70af70046aa0685f"
  end

  def install
    # Remove unused linux header
    inreplace "platform/Linux/vbesync.c", "#include <libdrm\/drm\.h>", ""
    # Replacement of htole16 for OS X
    inreplace ["sound/org.cpp", "sound/pxt.cpp"] do |s|
      s.gsub! "endian.h", "libkern/OSByteOrder.h"
      s.gsub! "htole16", "OSSwapHostToLittleInt16"
    end
    # Use var/nxengine for extracted data files, without messing current directory
    inreplace "graphics/font.cpp",
              /(fontfile) = "(\w+\.(bmp|ttf))"/,
              "\\1 = \"#{var}/nxengine/\\2\""
    inreplace "platform.cpp",
              /(return .*fopen)\((fname), mode\);/,
              "char fn[256]; strcpy(fn, \"#{var}/nxengine/\"); strcat(fn, \\2); \\1(fn, mode);"
    inreplace "graphics/nxsurface.cpp",
              /(image = SDL_LoadBMP)\((pbm_name)\);/,
              "char fn[256]; strcpy(fn, \"#{var}/nxengine/\"); strcat(fn, \\2); \\1(fn);"
    inreplace "extract/extractpxt.cpp",
              /(mkdir)\((\".+\")/,
              "char dir[256]; strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\2); \\1(dir"
    inreplace "extract/extractfiles.cpp" do |s|
      s.gsub! /char \*dir = strdup\((fname)\);/,
             "char *dir = (char *)malloc(256); strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\1);"
      s.gsub! "strchr", "strrchr"
    end

    system "make"
    bin.install "nx"
    pkgshare.install ["smalfont.bmp", "sprites.sif", "tilekey.dat"]
    resource("game").stage do
      pkgshare.install ["Doukutsu.exe", "data"]
    end
  end

  def post_install
    # Symlink original game data to a working directory in var
    (var/"nxengine").mkpath
    ln_sf Dir[pkgshare/"*"], "#{var}/nxengine/"
    # Use system font, avoiding any license issue
    ln_sf "/Library/Fonts/Courier New.ttf", "#{var}/nxengine/font.ttf"
  end

  def caveats; <<~EOS
    When the game runs first time, it will extract data files into the following directory:
      #{var}/nxengine
  EOS
  end
end
