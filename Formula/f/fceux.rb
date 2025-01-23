class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"
  revision 5
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  stable do
    url "https://github.com/TASEmulators/fceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/cd40795/fceux/2.6.6-arm.patch"
      sha256 "0890494f4b5db5fa11b94e418d505cea87dc9b9f55cdc6c97e9b5699aeada4ac"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "31754b6f7207bc00a48ea084ec06084b2cab1de6e6bebf1691b6f4d64e54b31e"
    sha256 cellar: :any,                 arm64_ventura: "896707c1bd55dee56878cde5feca245d73f8a55e8b781d5fb83c59e8989a110d"
    sha256 cellar: :any,                 sonoma:        "010e7a4a2b114a6799d7f8ec4bd5704c49433a6e720ecddd9bff1c416854077c"
    sha256 cellar: :any,                 ventura:       "a06a34bfe581b36a7791d93c5605cbdd6cff0af980688c09d64b97fd12e57289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "229f39e293d88f2c0d53075fa39b5246d3987e8c5264270597f55026952da5f2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libarchive"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"
  depends_on "x265"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib"
  end

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    fceux_path = OS.mac? ? "src/fceux.app/Contents/MacOS" : "src"
    libexec.install Pathname.new(fceux_path)/"fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~BASH
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    BASH
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"fceux", "--help"
  end
end
