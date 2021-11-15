class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.5.0",
      revision: "6c3a31a4f2c09be297a32f510e74b383f858773b"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "87c20cd5b6be81a5119f9efbe9dd5d6d7a7fd63c3c6eddaa09357d3dff75835a"
    sha256 cellar: :any, arm64_big_sur:  "87a20edafd956612816fc6ab2ab6aff610cad26f598c718a0864333b656e81f7"
    sha256 cellar: :any, big_sur:        "00cf9aad03f57fe2d8131171d706442630b8c641aec6cbd142a287cdd77a0f11"
    sha256 cellar: :any, catalina:       "f19d56cd871170a429c0ca92e188c45122f97c1896d153caf9a2b26bb4c88979"
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
