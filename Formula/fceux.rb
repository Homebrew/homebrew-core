class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"
  revision 4

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "7c7550b97011321d5d48f8f689c7158223aee5054698a6c707a185404e469e35" => :catalina
    sha256 "800e46a45f554876ad2a63ea6a62f6d672e5aefd2c9cca8f58fe615b82eb9ea7" => :mojave
    sha256 "3f587de213706a92fb02b14676514f6cba079e3c3b7ded2e57a8e718ebf9cf20" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "gd"
  depends_on "gtk+3"
  depends_on "sdl"

  # Does not build: some build scripts rely on Python 2 syntax
  disable! because: :does_not_build

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
