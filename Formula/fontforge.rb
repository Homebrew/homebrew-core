class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20201107/fontforge-20201107.tar.xz"
  sha256 "68bcba8f602819eddc29cd356ee13fafbad7a80d19b652d354c6791343476c78"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]

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
