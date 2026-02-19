class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  license "MPL-2.0"
  revision 1

  stable do
    url "https://github.com/mgba-emu/mgba/archive/refs/tags/0.10.5.tar.gz"
    sha256 "91d6fbd32abcbdf030d58d3f562de25ebbc9d56040d513ff8e5c19bee9dacf14"
    depends_on "qt@5"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "3de0f1241238f443a68c044e6261498b831e428c1e8b34e693e36d3eafdcf156"
    sha256 arm64_sequoia: "2562e2403616018e53173da2f532c6df31009ed4fac636b07b7c8e7ed291f51a"
    sha256 arm64_sonoma:  "7bc0c369ae51b10d7842496e5460857d1e52b0b03a0f9d9b70ef81338ab8f893"
    sha256 sonoma:        "87d1bc5459ba892d3a5bc079e330ee134a6f99889a0657966e94f76bfe90c1ca"
    sha256 arm64_linux:   "41d64491dfdec24fa9a2a943f83c4fa2b6fd8d8c121c7000cba09f61f9081b09"
    sha256 x86_64_linux:  "7f9ab3c875cdb0bd9f8cf13c006ee87677f411015e4b452a081dab51f7eaa3e5"
  end

  head do
    url "https://github.com/mgba-emu/mgba.git", branch: "master"

    depends_on "qttools" => :build
    depends_on "freetype"
    depends_on "qtbase"
    depends_on "qtmultimedia"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sqlite"

  uses_from_macos "libedit"

  on_macos do
    # https://github.com/mgba-emu/mgba/issues/3129
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    args = []
    # TODO: Remove minimum policy in 0.11. Upstream commit doesn't cleanly apply
    # https://github.com/mgba-emu/mgba/commit/e95b81f1f7b95161fbda81fa5e931e3bcb193ccf
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" if build.stable?
    # https://github.com/mgba-emu/mgba/issues/3115
    args << "-DUSE_DISCORD_RPC=OFF" if OS.linux?

    inreplace "src/platform/qt/CMakeLists.txt" do |s|
      # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
      s.gsub! "fixup_bundle(", "# \\0"
      # Install .app bundle into prefix, not prefix/Applications
      s.gsub! "Applications", "."
    end

    # Fix OpenGL linking on macOS.
    if OS.mac?
      if build.stable?
        inreplace "CMakeLists.txt",
                  "list(APPEND DEPENDENCY_LIB ${EPOXY_LIBRARIES})",
                  'list(APPEND DEPENDENCY_LIB ${EPOXY_LIBRARIES} "-framework OpenGL")'
      else
        # Work around failure running `cmake -E tar` within brew's build environment.
        # CMake Error: Unable to read from file 'fish.fs': Could not open extended attribute file
        # FIXME: Build is fine outside brew's environment
        args << "-DUSE_LIBZIP=OFF"
      end
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
