class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/refs/tags/0.10.4.tar.gz"
  sha256 "f85eeb8f78f847f5217a87bd5e2d6c1214b461ffd4ec129cc656162ab707cb24"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "4624835fbf821e296249530fb39bb84ebfdc9ba6d75afd023bb8dc700d0a26d4"
    sha256 arm64_sonoma:  "6b233122c9394407c50b5089e5639ae9fc7ff506512585fe2d56905652011eaf"
    sha256 arm64_ventura: "9c9d490eff972fceb18f02ec0b8a45f5cd438728b56b4ee373f407e3d2afde34"
    sha256 sonoma:        "7356ce6d1f974474443e09c262cf1c01053d8ec08dd7f394b22d05337b2f948a"
    sha256 ventura:       "041f4ab43ad9692860033e5165d33d6b0fb5cd6e117d978d67ca5932fa23fdc9"
    sha256 x86_64_linux:  "3becedeacabde85995ff2a61731bef63c4419fea90ee3d0bd4cc39ab5947f9ed"
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
