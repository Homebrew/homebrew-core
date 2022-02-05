class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.2",
      revision: "c685033a13127e8442549ff55b2554ed65ff3cfb"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "fd86a52e4df1d80f3f878673a0b33cef30650c9fe22df811d778bb461a151bd1"
    sha256 cellar: :any, arm64_big_sur:  "648f12111cd867edb1764a3f7f94703f2ee7fb30acc3d6c1c18c1da3cce4d46b"
    sha256 cellar: :any, big_sur:        "79180980ec29af0abca957a36e5e3128861fff044826d32b44d561b2a5794856"
    sha256 cellar: :any, catalina:       "950c00b6ac4187cae6248406075e858a2a9d115c0e876af2a793881d6d148e8c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5"

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
