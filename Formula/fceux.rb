class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.3",
      revision: "84cf82cb6a5b1d486523855e056ecebed34d7862"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ca8d296677efe2411d35bb74007259c4daa24f1d464709150684f1ee3828168e"
    sha256 cellar: :any, arm64_big_sur:  "d09db6f7a940654916002a49226113f1a936716ccae5901d870281f72bd0c17a"
    sha256 cellar: :any, monterey:       "2d8ee62c8e4f15e97d5cf52b07093a62ee69a0c2283e41bb03301bc1c3997b77"
    sha256 cellar: :any, big_sur:        "5cff74b8d555a3de7d14f420b5e7ec2474e07648e9e11985c9275a02dab035b2"
    sha256 cellar: :any, catalina:       "3ce20ce9e46e3cad0550ba1c832e3d4aba40d19d899e5f1c63ae4610afdd983f"
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
