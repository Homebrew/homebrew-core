class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.4",
      revision: "2b8c61802029721229a26592e4578f92efe814fb"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "014868c8f0454c13fb6ad090a4335c8348fc630bc95f7382b811498cf8991bac"
    sha256 cellar: :any,                 arm64_big_sur:  "530a4dd105ea8da50b1bcddc1a729b3788af6a817f8864a7af7c9bc3c1376f01"
    sha256 cellar: :any,                 monterey:       "4c5b724f4e3466dd522f875a5419a57353e9c8dd493562dc7ae35d4ff2f976df"
    sha256 cellar: :any,                 big_sur:        "e131aa7191a0a861b2b6c667bd0b42a2bb9e763e96a8e5ef6083d7083ebce88d"
    sha256 cellar: :any,                 catalina:       "7e3b7db25b0357708a66d3c8fa64599cbf0128bc4cb198842958796cce9a4e45"
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
