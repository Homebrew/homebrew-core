class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/refs/tags/0.10.5.tar.gz"
  sha256 "91d6fbd32abcbdf030d58d3f562de25ebbc9d56040d513ff8e5c19bee9dacf14"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "d8ebe6fbc8f70d57496bdebbc8fc268c85f0ffbfa43c75803f99373ad8e2c7c4"
    sha256 arm64_sonoma:  "384c4b392c485731de5660702fb07898aeeb84f75cf0034d8e9fb2d3d0580fa4"
    sha256 arm64_ventura: "2fbcf8eb43d84643bb7b785700ce107b73cdbe2355ae7fd644bae4a5b27a1365"
    sha256 sonoma:        "b48c92a1317213099f472790e21a95b2706caa5d4dc926d265947557fef71511"
    sha256 ventura:       "9c1ea93c98a50f653d8420817ca951ed455e8f9d9e75326e15ff490e89d4bb1c"
    sha256 x86_64_linux:  "1fcfaba1760543dc1cdbdf8c3f2a020d98aefe30d2050ee58d792ca2e6fb550f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libzip"
  depends_on "lua"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "sqlite"

  uses_from_macos "libedit"
  uses_from_macos "zlib"

  on_macos do
    # https://github.com/mgba-emu/mgba/issues/3129
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "mesa"
  end

  def install
    # https://github.com/mgba-emu/mgba/issues/3115
    args = []
    args << "-DUSE_DISCORD_RPC=OFF" if OS.linux?

    inreplace "src/platform/qt/CMakeLists.txt" do |s|
      # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
      s.gsub! "fixup_bundle(", "# \\0"
      # Install .app bundle into prefix, not prefix/Applications
      s.gsub! "Applications", "."
    end

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
