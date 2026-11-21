class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "v2.8.0",
      revision: "c40fcf6319cf5e03cf39e4295e553045e695c22c"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later", # src/drivers/common/{hq2x.cpp,nes_ntsc*}
    "MIT", # src/emufile*, src/drivers/Qt/TasEditor/, src/lua/
  ]
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    manifest_sha256 "13f8cbaa650c22f8ef211bb9b204f04c65ae8d8748e8cf01b6be3a6eed3a92d1"
    sha256 cellar: :any, arm64_golden_gate: "0996d2c8e778f922805d6a9523ef2cd7914cfce2b9eb152b7577e441b557980d"
    sha256 cellar: :any, arm64_tahoe:       "fe1cad4f405b6926036b14fff49cb0e0af5ff64f615bec52ac6c47515c8fc387"
    sha256 cellar: :any, arm64_sequoia:     "96553c4094173385986e18442268f46d4e553cda2e19d3a5dd4e6a6252fd919b"
    sha256 cellar: :any, arm64_linux:       "c4cc973354856b52c38b82fb7d43602332bf464269ae4fc949d5cf336e6b5977"
    sha256 cellar: :any, x86_64_linux:      "665a2064531c53ee16d24ea5526b41c6983512e8603d44034fddc0cd641cc802"
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
