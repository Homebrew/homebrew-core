class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.3",
      revision: "84cf82cb6a5b1d486523855e056ecebed34d7862"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "22e13ed6bc659da8e941863c7ef34f31385d31d766debaa71ad7c4f2878b4fc2"
    sha256 cellar: :any, arm64_big_sur:  "d267bc35a0b3230082e48c786e09d42b24e16ee5fe0223eabdab346c01b53612"
    sha256 cellar: :any, monterey:       "4dc044f7200df4dca1e80f041405e156e94a067ce940af83f81f77838859f3bc"
    sha256 cellar: :any, big_sur:        "b9b6430e809a99b47d3c7dcba39950d808f85b491dfa65068529776a2a4d07a6"
    sha256 cellar: :any, catalina:       "f867e4798505b2d2947dc0a5b2e9c659ba22b6bf67942d2f4309d2c93f5f47ed"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
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
