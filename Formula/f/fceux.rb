class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later", # src/drivers/common/{hq2x.cpp,nes_ntsc*}
    "MIT", # src/emufile*, src/drivers/Qt/TasEditor/, src/lua/
  ]
  revision 12
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
    sha256 cellar: :any, arm64_tahoe:   "09ce9e2a81d5d7600c1921921d3e402f50c809855b411669c91613b0a8978bef"
    sha256 cellar: :any, arm64_sequoia: "4741d14865c94f98a5f461304b7e73c725c36aae675c6345b8b36636f12100e8"
    sha256 cellar: :any, arm64_sonoma:  "b8fae46121fd239d11c29ede067bd8747b2df42c832561d1e71b766c70cd58e2"
    sha256               sonoma:        "8fe999ab9e68257e6cfb9c49bd98063f712361c4d15df40e2f907dfe1c045b21"
    sha256 cellar: :any, arm64_linux:   "975c645737c4eab968780d8a9f499ade39d8080dcb4c461c55df98f46f5005b8"
    sha256 cellar: :any, x86_64_linux:  "fc93c9a70f6d5e50ca69fa68d7513a156360eb2b6e4990c96bcc48115c525647"
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
