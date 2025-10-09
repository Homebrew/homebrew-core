class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20251009/fontforge-20251009.tar.xz"
  sha256 "69046500185a5581b58139dfad30c0b3d8128f00ebbfddc31f2fcf877e329e52"
  license "GPL-3.0-or-later"
  head "https://github.com/fontforge/fontforge.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "8243fc1912064ee3473f4b47b475a42ca75d41b7f12dcb7e48fb6d08972b73fb"
    sha256 arm64_sequoia: "1d1e28bec899066f42338f70cad7ccc45f943317f9b3745d352172d2bc3b4cf9"
    sha256 arm64_sonoma:  "f10e8516cf513c8cb07e445caaa6eefbb1ee8d878967f60b4217b79ff74469f2"
    sha256 sonoma:        "6f9e5800319bd7a8b5f9e09948f48ac60f39231ea0b3868790dba12afd59ec38"
    sha256 arm64_linux:   "6d832984d50f3dac855a70b11bf4d355863c133ad9c5c896f549345a55b37beb"
    sha256 x86_64_linux:  "39e1be688fa4fec3989fb159625f218c55a154b5c759ecd2943ae94b4fa0ebb3"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "woff2"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "brotli"
    depends_on "gettext"
  end

  def python3
    "python3.13"
  end

  def install
    args = %W[
      -DENABLE_GUI=OFF
      -DENABLE_FONTFORGE_EXTRAS=ON
      -DPython3_EXECUTABLE=#{which(python3)}
      -DPYHOOK_INSTALL_DIR=#{Language::Python.site_packages(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    on_macos do
      <<~TEXT
        This formula only installs the command line utilities.

        FontForge.app can be downloaded directly from the website:
          https://fontforge.github.io

        Alternatively, install with Homebrew Cask:
          brew install --cask fontforge
      TEXT
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/fontforge/fontforge/1346ce6e4c004c312589fdb67e31d4b2c32a1656/tests/fonts/Ambrosia.sfd"
      sha256 "6a22acf6be4ab9e5c5a3373dc878030b4b8dc4652323395388abe43679ceba81"
    end

    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    system python3, "-c", "import fontforge; fontforge.font()"

    resource("homebrew-testdata").stage do
      ffscript = "fontforge.open('Ambrosia.sfd').generate('#{testpath}/Ambrosia.woff2')"
      system bin/"fontforge", "-c", ffscript
    end
    assert_path_exists testpath/"Ambrosia.woff2"

    fileres = shell_output("/usr/bin/file #{testpath}/Ambrosia.woff2")
    assert_match "Web Open Font Format (Version 2)", fileres
  end
end
