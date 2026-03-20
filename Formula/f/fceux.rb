class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"
  revision 9
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
    sha256 cellar: :any,                 arm64_tahoe:   "9bbe75f88e4ef4f07b66016f279989d0152b3b9b4eda6205116248a8ff493e7f"
    sha256 cellar: :any,                 arm64_sequoia: "badb3805a8337d784f6708f2105b9c5b7cd388166ee101597011fb73e1ec3e3e"
    sha256 cellar: :any,                 arm64_sonoma:  "a9913d680aac448b262ee33b2e6e5296493e8c861c25859a08f4091fb5823848"
    sha256                               sonoma:        "3b270af853ae3f5485310667683262f23d2420940db6e1eaa0291a01e0d9409d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e56b704f9059aca2ac48e73eeae0c74ada48f58296ac98e58f5a6f69479044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d51564f3c8477453d8b0ea8045237bf8c8c73e770679b3a60518eeda71a3c40"
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
