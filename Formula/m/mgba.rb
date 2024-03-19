class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/refs/tags/0.10.3.tar.gz"
  sha256 "be2cda7de3da8819fdab0c659c5cd4c4b8ca89d9ecddeeeef522db6d31a64143"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "cb1a791928f65e72a215e2937ae260cbdd1ad4a3c6695801a1ac6593f5bee1d0"
    sha256 arm64_ventura:  "5e044fe7c3c9e0df33bbc45dbba8ae32b72b25127b9cbad4684dbfbd77b48710"
    sha256 arm64_monterey: "a0bb98ad810758e12b006bc6b27206dcd42feaf32998bbaf65f9fd6fa3fe669a"
    sha256 sonoma:         "0986dd98b5f3adfcf90f3372dcba1a7d8cf8ece9796aa1115dccca08130d966e"
    sha256 ventura:        "ad079c931238d8da4d171a2d3c7a5d11b3eb95df2f6c26f92f5953f0afc7b84c"
    sha256 monterey:       "a6084f9f33b2cc481946cd2fce2e0448cca7c5ec45de6f490b52d2ab58defc30"
    sha256 x86_64_linux:   "2ef0d04ceaaa58a6cc6a313f01a31ec89cb12c3942ddf06781b3df287760c7a2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libzip"
  depends_on "lua"
  depends_on "qt@5"
  depends_on "sdl2"

  uses_from_macos "sqlite"

  on_macos do
    # https://github.com/mgba-emu/mgba/issues/3129
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    # https://github.com/mgba-emu/mgba/issues/3115
    args = []
    args << "-DUSE_DISCORD_RPC=OFF" if OS.linux?

    # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
    inreplace "src/platform/qt/CMakeLists.txt", "fixup_bundle(", "# \\0"

    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    if OS.mac?
      bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
    else
      mv bin/"mgba-qt", bin/"mGBA"
    end
  end

  test do
    # mGBA opens a GUI with other commands, so we can only check the version
    assert_match version.to_s, shell_output("#{bin}/mGBA --version")
  end
end
