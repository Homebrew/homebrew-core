class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"

  stable do
    url "https://downloads.sourceforge.net/project/fceultra/Binaries/2.3.0/fceux-2.3.0.tar.gz"
    sha256 "f166f2fea084162f5b823bbbc6843141e23908ae4ee69c8c4e0849b320d7a1dc"
  end

  head do
    url "https://github.com/TASVideos/fceux.git"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
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
