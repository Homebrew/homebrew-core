class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.4",
      revision: "2b8c61802029721229a26592e4578f92efe814fb"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a7ac18f8e1221409874e872318e229ca6ca270595ea15cb8c853427ac27ad996"
    sha256 cellar: :any, arm64_big_sur:  "f7e4af1e770902a76a64fcc706fdacf9809d46f9fa092ba9f357d604f319614d"
    sha256 cellar: :any, monterey:       "a6d390d50682f2d6d22aa580fcca45dcf3cff770ab19ab83406978e424f6d3b2"
    sha256 cellar: :any, big_sur:        "bf62cad3e814927db5429ba30f3510bb548b847b0536e0e8b46ac542a256ed2c"
    sha256 cellar: :any, catalina:       "c94d8959edef6a194bd66cbd25a7c159147ab3bcb115f9e3e02b10312c260ac0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
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
