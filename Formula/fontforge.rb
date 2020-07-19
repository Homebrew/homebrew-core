class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20200314.tar.gz"
  sha256 "ad0eb017379c6f7489aa8e2d7c160f19140d1ac6351f20df1d9857d9428efcf2"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "6d2000c43d84a3353e7e27923c62ced0e5892338e69c6d341e61194cc70c1b4a" => :catalina
    sha256 "3c94c039f0524bdf6e4748f65b7677c9d73ecd07718221dbc8eb1c143fe236d1" => :mojave
    sha256 "1252f93604edae781fd5035ba5c367d820e341c13eec155bb24cf9ad5499dc4a" => :high_sierra
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
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libspiro"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "libuninameslist"
  depends_on "pango"
  depends_on "python@3.8"
  depends_on "readline"

  uses_from_macos "libxml2"

  # Remove with next release (cmake: adjust Python linkage)
  # https://github.com/fontforge/fontforge/pull/4258
  patch do
    url "https://github.com/fontforge/fontforge/pull/4258.patch?full_index=1"
    sha256 "3deed4d79a1fdf5fb6de2fca7da8ffe14301acbeb015441574a7a28e902561f5"
  end

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-GNinja",
                      "-DENABLE_GUI=OFF",
                      "-DENABLE_FONTFORGE_EXTRAS=ON",
                      *std_cmake_args
      system "ninja"
      system "ninja", "install"

      # The "extras" built above don't get installed by default.
      bin.install Dir["bin/*"].select { |f| File.executable? f }
    end
  end

  def caveats
    <<~EOS
      This formula only installs the command line utilities.

      FontForge.app can be downloaded directly from the website:
        https://fontforge.github.io

      Alternatively, install with Homebrew Cask:
        brew cask install fontforge
    EOS
  end

  test do
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import fontforge; fontforge.font()"
  end
end
