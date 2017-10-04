class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"

  bottle do
    cellar :any
    sha256 "edd46321234cc9a464368a907f3202ba74c68353a513661aae36b200667d0418" => :sierra
    sha256 "f581fdd1e3ba991f360be4f2bb1a011420436d614e26dba5b6bd66d1db459c7d" => :el_capitan
    sha256 "38d021833d4f42f9f781801dcebe23c780126b13b1d4923f96375cd9436fa48b" => :yosemite
  end

  deprecated_option "no-gtk" => "without-gtk+3"

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sdl"
  depends_on "gtk+3" => :recommended

  # Fix "error: ordered comparison between pointer and zero"
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c126b2c/fceux/xcode9.patch"
      sha256 "3fdea3b81180d1720073c943ce9f3e2630d200252d33c1e2efc1cd8c1e3f8148"
    end
  end

  def install
    system "2to3", "--write", "--fix=print", "SConstruct", "src/SConscript"

    # Bypass X11 dependency injection
    # https://sourceforge.net/p/fceultra/bugs/755/
    inreplace "src/drivers/sdl/SConscript", "env.ParseConfig(config_string)", ""

    args = []
    args << "RELEASE=1"
    args << "GTK=0"
    args << "GTK3=1" if build.with? "gtk+3"
    # gdlib required for logo insertion, but headers are not detected
    # https://sourceforge.net/p/fceultra/bugs/756/
    args << "LOGO=0"
    scons *args
    libexec.install "src/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<-EOS.undent
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
      EOS
  end

  test do
    system "#{bin}/fceux", "-h"
  end
end
