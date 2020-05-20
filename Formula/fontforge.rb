class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20200314.tar.gz"
  sha256 "ad0eb017379c6f7489aa8e2d7c160f19140d1ac6351f20df1d9857d9428efcf2"
  revision 1

  bottle do
    sha256 "f2a861d9e005be0529b4a9d18df5a0b71593f807c17b83aa079442b05a637cf9" => :catalina
    sha256 "9a1c7d709333b87451146f49e309f12126f8ae52036e2f459476d409b7ae7aca" => :mojave
    sha256 "5751d301e37649f5fb07cebd915be0a80a5443766ef23d70ef90dfe61bc1ff33" => :high_sierra
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
