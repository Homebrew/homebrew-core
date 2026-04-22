class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later", # src/drivers/common/{hq2x.cpp,nes_ntsc*}
    "MIT", # src/emufile*, src/drivers/Qt/TasEditor/, src/lua/
  ]
  revision 10
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  stable do
    url "https://github.com/TASEmulators/fceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/fceux/2.6.6-arm.patch"
      sha256 "0890494f4b5db5fa11b94e418d505cea87dc9b9f55cdc6c97e9b5699aeada4ac"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eda75ca31699038d2701df7112e28a64c5576885cf5a7071360dc941a491eaf1"
    sha256 cellar: :any,                 arm64_sequoia: "93fdf378700e89e4b70cba656619c560afcab371b387d5432f5f384347561eca"
    sha256 cellar: :any,                 arm64_sonoma:  "51e19e49e7678e85f05ed847d8ece770120abb775d522557ff4e98cfea3cedf1"
    sha256                               sonoma:        "6d3e851b8a1bfea64f473e05562347575e0a0a0b7dc601085e5549e0cbf9efe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671d185e43e348cf7e2b1a72ddd80fa6a08a477dd62f9f22a217492d4a8a50da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ae76477708e3f7b73e7065f16fd99470770f13bf5e98abfe3b3e02571b1665"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libarchive"
  depends_on "minizip"
  depends_on "qtbase"
  depends_on "sdl2"
  depends_on "x264"
  depends_on "x265"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround until upstream handles newer minizip 1.3.2 cflags after
    # https://github.com/madler/zlib/commit/7e6f0784cc0c33e8d5fcb368248168c6656f73c8
    ENV.append_to_cflags "-I#{Formula["minizip"].opt_include}/minizip"

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
