class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20201107/fontforge-20201107.tar.xz"
  sha256 "68bcba8f602819eddc29cd356ee13fafbad7a80d19b652d354c6791343476c78"
  revision 1

  bottle do
    sha256 "fdadc5e603cec702c46ce7d7cf71bc39ea8b61c1d7e41baaa6347af596ea8d75" => :big_sur
    sha256 "fa057842c812785b9fc515f8e52d50d5c05a18f1647474469edd34587e18e8c9" => :catalina
    sha256 "e3e59082b1b97574d9ed2ebb644a38df2d94e31e37a61a01726f578c49beef7a" => :mojave
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
        brew install --cask fontforge
    EOS
  end

  test do
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import fontforge; fontforge.font()"
  end
end
