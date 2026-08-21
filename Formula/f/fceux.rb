class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later", # src/drivers/common/{hq2x.cpp,nes_ntsc*}
    "MIT", # src/emufile*, src/drivers/Qt/TasEditor/, src/lua/
  ]
  revision 11
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  stable do
    url "https://github.com/TASEmulators/fceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      file "Patches/fceux/2.6.6-arm.patch"
    end

    # Fix builds with FFmpeg 9.
    patch do
      file "Patches/fceux/2.6.6-ffmpeg9.patch"
      type :unofficial
      resolves "https://github.com/TASEmulators/fceux/pull/850"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "92df75e7917ef2f4faeabad8adc78dea125ab3acf5443e9fd67e2d278a0ae2e3"
    sha256 cellar: :any, arm64_sequoia: "e700ee95280afdab48f196664c007404619fc7e9e4d2c88333cb76c3f8e077e9"
    sha256 cellar: :any, arm64_sonoma:  "c8fae80fef16812835d724185abc326b14824b592261e140e6d98289243f004b"
    sha256               sonoma:        "70ab74969a2f35f6daa44a8c512c4706fe9a730aff877b238e480be8b1b7231e"
    sha256 cellar: :any, arm64_linux:   "2b458ef6942759b53cc8d26d213cec088a76f7d65e268a1b15a87a8facd07539"
    sha256 cellar: :any, x86_64_linux:  "6b1058958a75ec98979e5d132e021f7bd90fb4bd2a247583b263c2d4518d63e7"
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

  def install
    # Workaround until upstream handles newer minizip 1.3.2 cflags after
    # https://github.com/madler/zlib/commit/7e6f0784cc0c33e8d5fcb368248168c6656f73c8
    ENV.append_to_cflags "-I#{formula_opt_include("minizip")}/minizip"

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
