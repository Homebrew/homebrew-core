class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20251009/fontforge-20251009.tar.xz"
  sha256 "69046500185a5581b58139dfad30c0b3d8128f00ebbfddc31f2fcf877e329e52"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/fontforge/fontforge.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fe4e8adc42c7763ed1e006c2966beea83baf6c012820391715a41cb8cd5af442"
    sha256 arm64_sequoia: "ea285c6bf59a9bcffdd24fbe0ae422c863b1eb0156015942ca1b76437291a424"
    sha256 arm64_sonoma:  "33997a1a5250790fd7e9df618d66ae2ba515b7739908423dbffa55141b984c7f"
    sha256 sonoma:        "b4603144bfe427dd67a0aa3a6d28d0bd77f4f7d074d95f538330b783027f7aec"
    sha256 arm64_linux:   "423e7dc51a951f9a5fff4693b96e8ee4bf542d3d7645e099244774f76b9fa015"
    sha256 x86_64_linux:  "8ce74cd480cd362e588066468c776c16ecbf48a967fe51fb769caa4db8837832"
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

  on_macos do
    depends_on "brotli"
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
