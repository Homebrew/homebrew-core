class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.0",
      revision: "1ca8b8e9d0c401b8a9687b019af30aa088d1c4d2"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "93e3ce6c5666a52b18e0bb4a700c9d1dbd4e1872f41538e3c11eb6a0eecc2fa7"
    sha256 cellar: :any, arm64_big_sur:  "82e755fc3934123d84e569b1db7141f73a64c008360d928289c51ef5659ac9b7"
    sha256 cellar: :any, big_sur:        "7b7f127696259777b51e9cc73899c64ad6ebd5011cd3fc1034a426b14857ab38"
    sha256 cellar: :any, catalina:       "433b61b512f6605d3aae9f9972cd1d4438bcff95c14177ef5caf2587c21746f9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
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
