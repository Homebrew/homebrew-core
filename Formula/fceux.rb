class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.1",
      revision: "7173d283c3a12f634ad5189c5a90ff495e1d266a"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "703f7ec022ed71552e97c4ef5a5360ffce048e67d47fa30afd1f1afa553efff6"
    sha256 cellar: :any, arm64_big_sur:  "77420fc7beb82bee75341c2f5d3a3dfe345c157d38da236b76f7661240cbc419"
    sha256 cellar: :any, big_sur:        "f5f782bb0539fbaac000448965e9793700fddeed03f016e5f99b64a4966fd52f"
    sha256 cellar: :any, catalina:       "362643ca9ed5af946a9ce13a92f92c765c33cca3fbf47e0fcf5d2409c227589f"
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
