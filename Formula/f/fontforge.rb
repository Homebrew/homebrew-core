class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20230101/fontforge-20230101.tar.xz"
  sha256 "ca82ec4c060c4dda70ace5478a41b5e7b95eb035fe1c4cf85c48f996d35c60f8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/fontforge/fontforge.git", branch: "master"

  bottle do
    rebuild 4
    sha256 arm64_sequoia: "f3efe932a2d7e72caf599601b82ee40144cb2ea3a1bef0afd5698b20ab11ff94"
    sha256 arm64_sonoma:  "0d843c5837f6634f8f3c2c2c2862f427f651d24670383e1a470a3e933e6065b4"
    sha256 arm64_ventura: "a6c3b3307443666523cc29b8bec912c6b1f933fe96580f061478b257ad0a992f"
    sha256 sonoma:        "174995c9c06977e05958d535f7065c443ecbd9b1a64f97c232f83296852866b9"
    sha256 ventura:       "ca33c447dc43b3f8d73bd42eb933b1fe1882794898cf387e4f22714d20ee6420"
    sha256 arm64_linux:   "4963da0c5611725c86b213cffd04f992fb778fa376ed5e0f58cd9144f7a55310"
    sha256 x86_64_linux:  "91cc737d5d5ff50542c7737cfe8f8f693d64a103b07839d7047a21cb9149e1ee"
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
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "woff2"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "brotli"
    depends_on "gettext"
  end

  # build patch for po translation files
  # upstream bug report, https://github.com/fontforge/fontforge/issues/5251
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9403988/fontforge/20230101.patch"
    sha256 "e784c4c0fcf28e5e6c5b099d7540f53436d1be2969898ebacd25654d315c0072"
  end

  def python3
    "python3.13"
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
