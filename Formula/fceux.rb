class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.4",
      revision: "2b8c61802029721229a26592e4578f92efe814fb"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "4e0229b41383077bc3ff7a3e9e43b4ebf248ebbb09d38078d89d7ea14d943a40"
    sha256 cellar: :any,                 arm64_big_sur:  "92c1e577709978b28cef7875358b6b5b3643f9301c56b5ae9eac98eaefd51bba"
    sha256 cellar: :any,                 monterey:       "cf55e27f1976a68608667cb3e5c7968c131e6d9a90e0691152784e1024006c19"
    sha256 cellar: :any,                 big_sur:        "e82e9537ee0427af36473a76b0b26198d22e577716c1e3c73ef6be45514c578d"
    sha256 cellar: :any,                 catalina:       "ace36678cd5d83047ca0038029e336f1833a80efd5c79ec88c1f02a78c4e1b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb660e38177e2fa16c4bf9006159238a9d0722e08f40728394f643e719a9b1f"
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
