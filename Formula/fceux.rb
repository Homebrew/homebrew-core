class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  revision 1
  license "GPL-2.0-only"

  version "2.3.0"

  stable do
    url "https://downloads.sourceforge.net/project/fceultra/Binaries/2.3.0/fceux-2.3.0.tar.gz"
    sha256 "f166f2fea084162f5b823bbbc6843141e23908ae4ee69c8c4e0849b320d7a1dc"
  end

  head "https://github.com/TASVideos/fceux.git"

  head do
    url "https://github.com/TASVideos/fceux.git"
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "sdl2"
  depends_on "minizip"

  def install

    system "cmake", ".", *std_cmake_args
    system "make"
    system "cp", "src/auxlib.lua", "output/luaScripts"
    libexec.install "src/fceux.app/Contents/MacOS/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    system "#{bin}/fceux", "--help"
  end
end
