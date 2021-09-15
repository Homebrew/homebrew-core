class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASVideos/fceux.git",
      tag:      "fceux-2.4.0",
      revision: "941da60ecb283263a3810ed199d80abf94bd6494"
  license "GPL-2.0-only"
  head "https://github.com/TASVideos/fceux.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3d03e8b04207f50eb560c5cb0343ec6600565bc24cf8b2dba1abb2f42e4ef288"
    sha256 cellar: :any, big_sur:       "2d900d6d428da14dc3cc5a2cb651bbc61a840c56271aa85fee6eec76fe781935"
    sha256 cellar: :any, catalina:      "c5eaa79f94834d5f38399293de563f292f03f175b5a7968251ae45887f07f120"
    sha256 cellar: :any, mojave:        "536f893139bcd6fd413eaa457d996c9df6b184ca89f267253f01312971c6cb39"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "minizip"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "x264"

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
