class Lektra < Formula
  desc "High-performance document and image viewer"
  homepage "https://dheerajshenoy.github.io/lektra"
  # The bundled libraries (MuPDF, LuaJIT, MicroTeX, SyncTeX, tinyxml2) are git
  # submodules, which GitHub release tarballs do not contain, so fetch with git.
  url "https://github.com/dheerajshenoy/lektra.git",
      tag:      "v0.8.2",
      revision: "7fa2922798bc3a36e6b65b8bef25668ce2112fe1"
  license "AGPL-3.0-only"
  head "https://github.com/dheerajshenoy/lektra.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build # LinguistTools (lrelease)
  depends_on "fontconfig"
  depends_on "libarchive"
  depends_on "qtbase"
  depends_on "qtsvg"

  on_linux do
    depends_on "brotli"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      -DWITH_CCACHE=OFF
      -DWITH_LLD=OFF
    ]

    # Use Homebrew's legacy libGL (mesa), not the host's GLVND libOpenGL/libGLX.
    args << "-DOpenGL_GL_PREFERENCE=LEGACY" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # On macOS CMake installs a lektra.app bundle into the prefix, so expose
    # the executable inside it as `bin/lektra`.
    bin.write_exec_script prefix/"lektra.app/Contents/MacOS/lektra" if OS.mac?
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    assert_match version.to_s, shell_output("#{bin}/lektra --version")
  end
end
