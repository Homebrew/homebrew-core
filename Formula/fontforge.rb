class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20230101/fontforge-20230101.tar.xz"
  sha256 "ca82ec4c060c4dda70ace5478a41b5e7b95eb035fe1c4cf85c48f996d35c60f8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "e4e49fa2cc9c3ea67878e771264b3fc98b23f3e2b5046ab28c644a7fead33143"
    sha256 arm64_monterey: "daba676ad4d1ba5a160d883bffa73bfc189c68b571b1799275d8d65da4b34d24"
    sha256 arm64_big_sur:  "24f77f4cea3d1d100c744e60abe044fd82a5e87846b206f1e4e34232ebc7a5d6"
    sha256 ventura:        "e41f49422bd52bdaa48ef9d22f8e9c9de11ee1718b01929362da322ec0b82905"
    sha256 monterey:       "c4681106deccb919618b65408cc0ca1f6cd5caf7a59cad0f136268e20979e254"
    sha256 big_sur:        "e74714a52891d601fb1e053516a1ccd165c5146f52d8e84a658dc8cbe463ed77"
    sha256 x86_64_linux:   "53ab801d9f1841f30771b4bddefd465733bb87ce3cbf67cefaf52efc9eaf0eab"
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
