class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"

  license "GPL-2.0-only"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d4354cc40673c347bda3c50d5658fd207362a8b172b04e06c82d1adb7f5e6dc8"
    sha256 cellar: :any,                 arm64_ventura:  "68e1c26fa0a93d22dfe111d22665a30159845793e2622ec67bfc59f52f383e5b"
    sha256 cellar: :any,                 arm64_monterey: "98d448c3cdd2ad2223e02008302927e9b98f155e9d6a8aaf95dc4473747a2eb0"
    sha256 cellar: :any,                 sonoma:         "0ce27ffa7be3908c2c797913a795017f6c581ecdb084ed4f83142cd50ec09ba8"
    sha256 cellar: :any,                 ventura:        "b0e0c109c847ee0ab21e3f0acb8d1f0c24f4b2599701a33753ec4b638784a96b"
    sha256 cellar: :any,                 monterey:       "49e1c8b8856d4181cc4da5fab6997f2da33540dc82038051549829ca768a7072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e47ed2db6b81d031a7ac9ce88a1815097fcadd4ff81cada95747db2687724ad"
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
