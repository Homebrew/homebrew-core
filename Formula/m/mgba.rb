class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/refs/tags/0.10.3.tar.gz"
  sha256 "be2cda7de3da8819fdab0c659c5cd4c4b8ca89d9ecddeeeef522db6d31a64143"
  license "MPL-2.0"
  revision 1
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "d25d99aa5db8c8e0c860a7687b81fba01607282028f9e27cce4c1f92fddf7a6a"
    sha256 arm64_ventura:  "b7a07ec0ed66d699a0fa40a780aa46b2bf22491223beb111b33e16df6ae1e94c"
    sha256 arm64_monterey: "948767938e7aeaeabd951f600a1907018e42f3eabf559a97a5865074b2e1ca4f"
    sha256 sonoma:         "3089a1cdc7212c1b45bd4cb8f09909f76fb2fd11cc2900d9ed4ceff82b958545"
    sha256 ventura:        "7ecd5443f866e0de40fcfac597266bda37fe1cb0fe2f4b5ba6cbf297f57279ca"
    sha256 monterey:       "6cc7a183ecfe59b30ed0211682fcc04ba755bd40d42a98deed8e032831abdbca"
    sha256 x86_64_linux:   "36cf3e2fd99036777e5dfe0566a34003e526c5b6e500e5afd9ac2f3db24d19d0"
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

    # Fix OpenGL linking on macOS.
    if OS.mac?
      inreplace "CMakeLists.txt",
                "list(APPEND DEPENDENCY_LIB ${EPOXY_LIBRARIES})",
                'list(APPEND DEPENDENCY_LIB ${EPOXY_LIBRARIES} "-framework OpenGL")'
    end

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
