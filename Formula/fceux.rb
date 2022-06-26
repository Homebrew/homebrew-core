class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.4",
      revision: "2b8c61802029721229a26592e4578f92efe814fb"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b487aace664447205f9aa223f343c9b0b40dd46af80faf06f8afade175d6bd2"
    sha256 cellar: :any,                 arm64_big_sur:  "3a52c3f3c2784ff73890b37a66aebfdb1de0d239a6e909a0656c8beda45534a9"
    sha256 cellar: :any,                 monterey:       "f5430a054f5eb0bff5797bc71c487943a22ee156815ee39b4f0700c907e28f5a"
    sha256 cellar: :any,                 big_sur:        "462d04dd0ef169b5e85c80eb2f62443747ab9d3af3ce99e7096a687b01185a50"
    sha256 cellar: :any,                 catalina:       "ff69736d07f7836d141565d16c682b5f2a5fa8abfd386b63aa373f1736d13895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51dfaab2b7752e008015a46c7ff551187d273ad100a1f96a0ea7266859b41605"
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
