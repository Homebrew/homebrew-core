class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20230101/fontforge-20230101.tar.xz"
  sha256 "ca82ec4c060c4dda70ace5478a41b5e7b95eb035fe1c4cf85c48f996d35c60f8"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "864cdef006295be1c065314cc6caad3f9ebbdb3c0f6c6c832649d92af7327d44"
    sha256 arm64_monterey: "941de4b89e7cedda2477e4c0024c8ab3e1e200117c516a5c76a6cf129d61bc9c"
    sha256 arm64_big_sur:  "7d48ebc8e93c097808422cda06e15e580629afeb7e02475d916b635f93f1d581"
    sha256 ventura:        "1b7d154062de6f9134800d2c422288243a67f6e9c32921b173fb3dfe49a235b4"
    sha256 monterey:       "a698046927fda5202622adf5c7f2c1f0d3b040fca05b82629f125156fa53ce62"
    sha256 big_sur:        "2f92236bf0eb3b88a2d567767b3bf1da6e77442b570483b1f2ccefc98cbfdd5c"
    sha256 x86_64_linux:   "02d40377c37e0af482f856c6a2c225e1c73a48109d8006b2b6fbe4d1a0de3a3c"
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
