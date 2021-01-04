class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"

  stable do
    url "https://downloads.sourceforge.net/project/fceultra/Binaries/2.3.0/fceux-2.3.0.tar.gz"
    sha256 "f166f2fea084162f5b823bbbc6843141e23908ae4ee69c8c4e0849b320d7a1dc"
  end

  bottle do
    cellar :any
    sha256 "7c7550b97011321d5d48f8f689c7158223aee5054698a6c707a185404e469e35" => :catalina
    sha256 "800e46a45f554876ad2a63ea6a62f6d672e5aefd2c9cca8f58fe615b82eb9ea7" => :mojave
    sha256 "3f587de213706a92fb02b14676514f6cba079e3c3b7ded2e57a8e718ebf9cf20" => :high_sierra
  end

  head "https://github.com/TASVideos/fceux.git"

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
