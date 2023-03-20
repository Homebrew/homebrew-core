class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "v2.6.5",
      revision: "ea6ed69b874e3ae94072f1b4f14b9a8f0fdd774b"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84fc7e01a4bd37c50e66856663c0a85ad6a10b0a7092583ea76daa4e27f31b4d"
    sha256 cellar: :any,                 arm64_monterey: "7c176a75a109ae6351a3b53a0f791cc440498591039655ee9d951b77567c39a8"
    sha256 cellar: :any,                 arm64_big_sur:  "ed09257356077299043e5e2a00fe48a209de8931bd282d1687ed890dcdda20fb"
    sha256 cellar: :any,                 ventura:        "7bb7541203311e9e12c240eee8d9f3e00788cffd810db4715189b4fbe5b392a7"
    sha256 cellar: :any,                 monterey:       "4cb78e1bdff952dcb42bf2f5f90b8a12e178d64947fa9d41a53ce300042fc321"
    sha256 cellar: :any,                 big_sur:        "0f0bd1643792ad6c2882b801d40fc2fd6ba5e4174858ef6a71fa6a47a68e8ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cb6b743e7b5d5ed218cc90d886705fcdad77cfe33d480c188e521d4e3d2b1d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    fceux_path = OS.mac? ? "src/fceux.app/Contents/MacOS" : "src"
    libexec.install Pathname.new(fceux_path)/"fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/fceux", "--help"
  end
end
