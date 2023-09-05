class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20230101/fontforge-20230101.tar.xz"
  sha256 "ca82ec4c060c4dda70ace5478a41b5e7b95eb035fe1c4cf85c48f996d35c60f8"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "9046c0e8c9b22e734124680b0ada61d6205fffcdcc3e390e730bc7782508d227"
    sha256 arm64_monterey: "8effca8a77d5c2622ca337c4432e935259b02f72cdb60aaefe00c232dcec728f"
    sha256 arm64_big_sur:  "76ce570594897169977ae31c6b7365f04168eec804a743c807213e0844c755a2"
    sha256 ventura:        "bd63ee28f83dec665137eb003994a9e39a159c14e3ae104fb8cb5b7878f3d858"
    sha256 monterey:       "3861d0866438662ff819393a8a1f2ca896f621417fc5aaf8269f5db45ae309b1"
    sha256 big_sur:        "4b7f3290b74c518c7e1dfb246a51208d61365ac79762934ce4b7261fa990ccdd"
    sha256 x86_64_linux:   "68b6ce1b252505ed77ad7cf427c26aa892f68fb46115f7006e638d21c5a9aa26"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
  depends_on "python@3.11"
  depends_on "readline"
  depends_on "woff2"

  uses_from_macos "libxml2"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/fontforge/fontforge/1346ce6e4c004c312589fdb67e31d4b2c32a1656/tests/fonts/Ambrosia.sfd"
    sha256 "6a22acf6be4ab9e5c5a3373dc878030b4b8dc4652323395388abe43679ceba81"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-GNinja",
                    "-DENABLE_GUI=OFF",
                    "-DENABLE_FONTFORGE_EXTRAS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    on_macos do
      <<~EOS
        This formula only installs the command line utilities.

        FontForge.app can be downloaded directly from the website:
          https://fontforge.github.io

        Alternatively, install with Homebrew Cask:
          brew install --cask fontforge
      EOS
    end
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    system python, "-c", "import fontforge; fontforge.font()"

    resource("homebrew-testdata").stage do
      ffscript = "fontforge.open('Ambrosia.sfd').generate('#{testpath}/Ambrosia.woff2')"
      system bin/"fontforge", "-c", ffscript
    end
    assert_predicate testpath/"Ambrosia.woff2", :exist?

    fileres = shell_output("/usr/bin/file #{testpath}/Ambrosia.woff2")
    assert_match "Web Open Font Format (Version 2)", fileres
  end
end
