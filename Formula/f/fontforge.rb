class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20230101/fontforge-20230101.tar.xz"
  sha256 "ca82ec4c060c4dda70ace5478a41b5e7b95eb035fe1c4cf85c48f996d35c60f8"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "c469b0719fd1508209c51f63b9b6ec7cbcec1e1a5ccef291b7f3cce07fc29eb1"
    sha256 arm64_ventura:  "74a6767564dce1cff1d76a09205f8e3ad898e102de8f6cdfbc175c1574c9adc0"
    sha256 arm64_monterey: "3c7e39a9784914c5a11bd9950913494d2da29d85ea3a46b7c0fd2c11d438302a"
    sha256 sonoma:         "920a7a9f4c5e6da5107e718a4d6b81b9a120baf8dcc8c5c26d22b8b9310cd761"
    sha256 ventura:        "25e4c95dffa16736af0f10dbe502512c3def848dc6ab3d30e4f7c850298d1e08"
    sha256 monterey:       "c063d659309fb9232cc6cbd3fcad9cc8866592cbd586fa0bfb06459eed56df96"
    sha256 x86_64_linux:   "0e9d06b7cede17c0c86db0d9b8ef929afae412fa8f84ad12363a387db304fe20"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build

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
  depends_on "python@3.12"
  depends_on "readline"
  depends_on "woff2"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "brotli"
  end

  # build patch for po translation files
  # upstream bug report, https://github.com/fontforge/fontforge/issues/5251
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9403988/fontforge/20230101.patch"
    sha256 "e784c4c0fcf28e5e6c5b099d7540f53436d1be2969898ebacd25654d315c0072"
  end

  def install
    args = %w[
      -DENABLE_GUI=OFF
      -DENABLE_FONTFORGE_EXTRAS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/fontforge/fontforge/1346ce6e4c004c312589fdb67e31d4b2c32a1656/tests/fonts/Ambrosia.sfd"
      sha256 "6a22acf6be4ab9e5c5a3373dc878030b4b8dc4652323395388abe43679ceba81"
    end

    python = Formula["python@3.12"].opt_bin/"python3.12"
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
