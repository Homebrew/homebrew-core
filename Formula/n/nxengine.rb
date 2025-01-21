class Nxengine < Formula
  desc "Rewrite of Cave Story (Doukutsu Monogatari)"
  homepage "https://nxengine.sourceforge.io/"
  url "https://nxengine.sourceforge.io/dl/nx-src-1006.tar.bz2"
  version "1.0.0.6"
  sha256 "cf9cbf15dfdfdc9936720a714876bb1524afbd2931e3eaa4c89984a40b21ad68"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "30307c765872608edcbb316a1d2f09a4018b1024565b7648864ed895748cede7"
    sha256 cellar: :any, arm64_ventura:  "dbf17c0f5d0c2ca0ff0f2065595593196d098b62004ef56bb5116907e63d6028"
    sha256 cellar: :any, arm64_monterey: "08131c36364793644508be87253a08535f9e6162c3e5c5506bcf28053b496ddf"
    sha256 cellar: :any, arm64_big_sur:  "4e95b8a7bba3017394e2a9c0cc3e3aeaa505a09b6491277a3a1eec7fd789d646"
    sha256 cellar: :any, sonoma:         "d2be0c1d77820f9e8008c5389021583373720428f3228702988a74b865fbdacf"
    sha256 cellar: :any, ventura:        "c57b40920cce4c09cd03cb85a1b2057acfcfdad6c073f78dcd6185659ff0f6c0"
    sha256 cellar: :any, monterey:       "64f5d24d27a052676ef63aa8f6624f77412f36031f9d6f3486fcbf9f232dfacb"
    sha256 cellar: :any, big_sur:        "8f73644dde241df28e005921c7b82d904466c87a0c3dd5e6ea0b72ad595a242b"
    sha256 cellar: :any, catalina:       "be3f2bcd0f8d5e04c25224d6ddeb0c0e11ec64627266ee35f79f5c35c1511264"
  end

  # Last release on 2014-07-15
  disable! date: "2024-02-07", because: "uses deprecated `sdl_ttf`"

  depends_on "sdl12-compat"
  depends_on "sdl_ttf"

  # Freeware Cave Story 1.0.0.6 pre-patched with Aeon Genesis English translation
  resource "game" do
    url "https://www.cavestory.org/downloads/cavestoryen.zip"
    sha256 "aa87fa30bee9b4980640c7e104791354e0f1f6411ee0d45a70af70046aa0685f"
  end

  def install
    # Remove unused linux header
    inreplace "platform/Linux/vbesync.c", "#include <libdrm/drm.h>", ""
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
              /(mkdir)\((".+")/,
              "char dir[256]; strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\2); \\1(dir"
    inreplace "extract/extractfiles.cpp" do |s|
      s.gsub!(/char \*dir = strdup\((fname)\);/,
             "char *dir = (char *)malloc(256); strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\1);")
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

  def caveats
    <<~EOS
      When the game runs first time, it will extract data files into the following directory:
        #{var}/nxengine
    EOS
  end
end
