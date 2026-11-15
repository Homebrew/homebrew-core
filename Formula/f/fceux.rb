class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.7.0",
      revision: "a6d03e7968bd77a8156a7c9b628a673753f2f4c6"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later", # src/drivers/common/{hq2x.cpp,nes_ntsc*}
    "MIT", # src/emufile*, src/drivers/Qt/TasEditor/, src/lua/
  ]
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7fa07490642ef50f0ce1c61e4e7ee2fb520432cabb06ec225153b5700e131e5b"
    sha256 cellar: :any, arm64_tahoe:       "434227872e81c93b79deb5819af139d244bb50d3342fd62a3bad56a616d6880b"
    sha256 cellar: :any, arm64_sequoia:     "c0521f7ce98b252748fa7914071ccf2bc18adfa3963c40d2a915139802a5b37b"
    sha256 cellar: :any, arm64_linux:       "aa28e120a9db3dcb3a14763a773ea33e51387546d87150b22d70c902c6044ca8"
    sha256 cellar: :any, x86_64_linux:      "a4ae0367e9933d888cafe50f5fa293c7976e1c366b1b0be8d1119ebf87f397e2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libarchive"
  depends_on "minizip"
  depends_on "qtbase"
  depends_on "sdl2-compat"
  depends_on "x264"
  depends_on "x265"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = ["-DQT6=ON"]
    args << "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    if OS.mac?
      cp "src/auxlib.lua", "output/luaScripts"
      bin.install "src/fceux.app/Contents/MacOS/fceux"
      pkgshare.install "output/luaScripts", "output/palettes", "output/tools"
    else
      system "cmake", "--install", "."
    end
    bin.env_script_all_files libexec, LUA_PATH: "#{pkgshare}/luaScripts/?.lua"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"fceux", "--help"
  end
end
