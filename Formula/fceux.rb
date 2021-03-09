class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASVideos/fceux.git",
      tag:      "fceux-2.3.0",
      revision: "65c5b0d2a1c08db75bb41340bfa5534578926944"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/TASVideos/fceux.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2670e9ad02d6fcced8178967625bc9ad7e04772eadaf78a3a98cd4e2b452396c"
    sha256 cellar: :any, big_sur:       "ab311b3b0e73d4cde15fd0c95ee221f6dfc0a239fb10c109c94c393cb0cc3782"
    sha256 cellar: :any, catalina:      "bd7ddafbbe5357afa8db61d66004fb4ee3dafe67019a68646f7cf3653fc620ac"
    sha256 cellar: :any, mojave:        "5e0d118e90f6333350a654e9c77627ef2703018cbda58589ea36580bf6542ced"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "minizip"
  depends_on "qt@5"
  depends_on "sdl2"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
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
