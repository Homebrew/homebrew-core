class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"
  revision 7
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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a963c27f406d7c364e12c272e058e20eb2805a1002769fded6b0e998df0d0ab8"
    sha256 cellar: :any,                 arm64_sequoia: "c0cdaad08a0323f11edb6db89c7f50c018b2e4f1021c5e1cad66ac18d3f5a305"
    sha256 cellar: :any,                 arm64_sonoma:  "c03762741adede92ee199469213b5a6ebf7ee634fbe294c4ee3f3370b4494988"
    sha256                               sonoma:        "e38989774281ec572e98c9e09f4ebfb4403665b6964a0c7845dfd9c7c824e2ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b5e684062b836bfc484140572a58e3ff7f0b0b5b43337181a9f35a2f3c67b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8a531cd8a3c7be8f095419340bc7ecc76d387fa593757b3aa06515da3ce0a2"
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

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
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
