class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASVideos/fceux.git",
      tag:      "fceux-2.3.0",
      revision: "65c5b0d2a1c08db75bb41340bfa5534578926944"
  license "GPL-2.0-only"
  head "https://github.com/TASVideos/fceux.git"

  bottle do
    cellar :any
    sha256 "ebc63da5d126fd47a5df151fabb90a711b4da9859465d42bd8654c55ade77c62" => :big_sur
    sha256 "a369411e4073f2c00f531efce9a9106905f79278db34e9631deb86c6a3f2b884" => :arm64_big_sur
    sha256 "cfec571f34128f228777843a9089a6c48f0799a2c0d873b65f5ebfde2357a849" => :catalina
    sha256 "ea023c53472bdb9ed928f31bdd9e149c28376b45e9f419c799efc77f70b76110" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "minizip"
  depends_on "qt"
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
