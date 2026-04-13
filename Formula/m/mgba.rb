class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  license "MPL-2.0"
  revision 2

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
    sha256 arm64_tahoe:   "8411364c77931ae04e12dd3b53f2774340b1b57bf38a13feb4f3698d629acf31"
    sha256 arm64_sequoia: "4159fa434f32672ec81962e42b2d19793b4a7f0cb785e9813efd365edec522a9"
    sha256 arm64_sonoma:  "d18b171103b78bc18a6f6e20e70bd5fdfc57b222b75d9f7134fa029dd211b712"
    sha256 sonoma:        "b6f194de7413b6116a40547f1f1b704c459f92077a825a4c448748bd6d249bdb"
    sha256 arm64_linux:   "5fa6abdc364db3f23966f56256075cd45285a43af359c70b8734ca37e53978b4"
    sha256 x86_64_linux:  "222d1ca423303f2566862188a3ad8cfbf5494b812e6191b0c7ccccc7b8555e84"
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
