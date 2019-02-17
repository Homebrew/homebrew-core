class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"
  revision 1

  bottle do
    cellar :any
    sha256 "5c0c3d6c59e39e053a1d64605f57a9e05fce54f62c8b9778ffb4103708842f23" => :mojave
    sha256 "b075151a3db5a502f98f6ee8b5fcbd5ffa05064a88c786c99fa9fa908b85eacf" => :high_sierra
    sha256 "4102c16cb5f5412d36cdcc52f739c98c2f457be7a8d4f0a55aa6f973eeb8c39d" => :sierra
    sha256 "013d1b9b126426b76e814b56a5424281c348333e6a6e69db87cf603362c25397" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "gtk+3"
  depends_on "sdl"

  # Fix "error: ordered comparison between pointer and zero"
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c126b2c/fceux/xcode9.patch"
      sha256 "3fdea3b81180d1720073c943ce9f3e2630d200252d33c1e2efc1cd8c1e3f8148"
    end
  end

  def install
    # Bypass X11 dependency injection
    # https://sourceforge.net/p/fceultra/bugs/755/
    inreplace "src/drivers/sdl/SConscript", "env.ParseConfig(config_string)", ""

    # gdlib required for logo insertion, but headers are not detected
    # https://sourceforge.net/p/fceultra/bugs/756/
    system "scons", "RELEASE=1", "GTK=0", "GTK3=1", "LOGO=0"
    libexec.install "src/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    system "#{bin}/fceux", "-h"
  end
end
