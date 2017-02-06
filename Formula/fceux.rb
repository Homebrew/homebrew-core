class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"

  bottle do
    cellar :any
    sha256 "c723e1517167dc9087b5cb8f439c33eed99fde01cb955a651c3740dfd44ebcfb" => :sierra
    sha256 "cc0491307589e13881b88485811d3b647fdbe32f5a622561b7d84c139a400b12" => :el_capitan
    sha256 "7390f528ee617ed31110fffb5eeec0dc730013b5826364793dd7af691ae54fd1" => :yosemite
  end

  deprecated_option "no-gtk" => "without-gtk+3"

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sdl"
  depends_on "gtk+3" => :recommended

  def install
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
