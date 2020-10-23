class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/archive/20200314.tar.gz"
  sha256 "ad0eb017379c6f7489aa8e2d7c160f19140d1ac6351f20df1d9857d9428efcf2"
  license "GPL-3.0"
  revision 2

  bottle do
    sha256 "1e71933145235afca40aeb357ff8d0ee6ec9461e5b4f7607b7b935cbbf07c0ae" => :catalina
    sha256 "621b45bbce2fb407847fa5978eda807561288a8ba793dbc18b9f6cb089fac756" => :mojave
    sha256 "aeff8baaaadf3bb54734feae6a75e8868291a5cb8441e88e5fd13772a08f5ccf" => :high_sierra
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
  depends_on "python@3.9"
  depends_on "readline"

  uses_from_macos "libxml2"

  # Remove with next release (cmake: adjust Python linkage)
  # Original patchset: https://github.com/fontforge/fontforge/pull/4258
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/99af4b5/fontforge/20200314.patch"
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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import fontforge; fontforge.font()"
  end
end
