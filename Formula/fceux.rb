class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"
  revision 2

  bottle do
    cellar :any
    sha256 "dc3c25ea5a685c59eced0d705e43ef72cdd42e3cf21cdb48c0ca02ebd2494a64" => :mojave
    sha256 "86dcccdeb382c68cb9b00393780def76257b27d14b897caffd044ae0f2afba10" => :high_sierra
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
