class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20251009/fontforge-20251009.tar.xz"
  sha256 "69046500185a5581b58139dfad30c0b3d8128f00ebbfddc31f2fcf877e329e52"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/fontforge/fontforge.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "9842a2fb9af32ffb0b9f42eee17632315a97851b78c7f8200d174604470137e7"
    sha256 arm64_sequoia: "84ec0be09f626a8742659e590293b827e59dce3b17db7df66f7edcfebd04af36"
    sha256 arm64_sonoma:  "c3709d57ce02996b5a78de23cbdcb3d23bcd1c905d51b36ffa8df0c5c89cd545"
    sha256 sonoma:        "d69b2a27564efd612d118c3d21af11ed90884a0b6ab39d4a1f4aaad0ec2c2aef"
    sha256 arm64_linux:   "4f5dda211c788f14f2e496718afc1e4a76652a3f09a7542b5c5970ac9b8e90b5"
    sha256 x86_64_linux:  "c7670ee26c9d7fc053de2c9b0c17d84e801abf7c06e7d1f354cf4eb2204a0a09"
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
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "woff2"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "brotli"
    depends_on "gettext"
  end

  def python3
    "python3.14"
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
