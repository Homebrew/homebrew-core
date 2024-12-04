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

    # x265 4.0/4.1 build patch, upstream pr ref, https://github.com/TASEmulators/fceux/pull/766
    patch do
      url "https://github.com/TASEmulators/fceux/commit/a6fcb73b11fc518dc60495acd408fcaf4c423baa.patch?full_index=1"
      sha256 "36a6d32451cf568a292456b549e6c4fecf17bf1ebd2e41ba2a7fc103f2796a0c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "c3594d0215425a0e72abe7c7234eaba3dfa46b85dc4dd01ba03dd0f1a422a50e"
    sha256 cellar: :any,                 arm64_ventura: "ac3ba77489705d69cb38841e46e6387c1f4e0296a0850b86371d428240325d56"
    sha256 cellar: :any,                 sonoma:        "fe93346ca1683b5dcecb5cf4df2296ea345422354b46714c1f1365a8a962c71c"
    sha256 cellar: :any,                 ventura:       "bfb3e74a9bb2ebacd321c553eb170991e16fc361c547ae56887b61360b355f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5e0fd981b3b0245b4b9df311b69fb00fe65fe652622a8d3d30f24d0b18fc44"
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
