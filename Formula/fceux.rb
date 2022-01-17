class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.1",
      revision: "7173d283c3a12f634ad5189c5a90ff495e1d266a"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "90f731fec114036b892738bfb92dca2e732d504f799cca51c44f73dc1da245cb"
    sha256 cellar: :any, arm64_big_sur:  "1ea1e8b6dd10cf7919c5e196270b122e207917e7e4a373d80b4a6afd58062e62"
    sha256 cellar: :any, big_sur:        "9f321786d859c2553882e05313a774e4f8b97efb6976ec3c6310c1b6f7a22145"
    sha256 cellar: :any, catalina:       "d805ab7115b26a6c95c37711ad34043116f54abe2e276b07e77fe1d4bef73fa4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "x264"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    libexec.install "src/fceux.app/Contents/MacOS/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    system "#{bin}/fceux", "--help"
  end
end
