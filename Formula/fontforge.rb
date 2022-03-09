class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20220308/fontforge-20220308.tar.xz"
  sha256 "01e4017f7a0ccecf436c74b8e1f6b374fc04a5283c1d68967996782e15618e59"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "523104e5ae79fddfcf373f8ed9ce4d103ae064009c725cf26f9d5df25a06c7cf"
    sha256 arm64_big_sur:  "1930327e9bf9b50fc4d55c5279b2c2ace119e570772513ddf469de4cb9a64380"
    sha256 monterey:       "899436bea1a2bd257f034e09b19874bd2a600885b025a20cb5439c66c0f27009"
    sha256 big_sur:        "20d25fae548d111f036e5ea9d268652b24deb7f21e9a0188fa2da29b46125414"
    sha256 catalina:       "5e25c98ac914f0a54c9d7cacc27eac8c5e415429f387c136b97aa2d6ea222ac8"
    sha256 x86_64_linux:   "92810f5489f44a7ec3b372c8e0f4b9d0fcff671570c4ef6c56334cb4327bbe47"
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

  # Fix for rpath on ARM
  # https://github.com/fontforge/fontforge/issues/4658
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-GNinja",
                      "-DENABLE_GUI=OFF",
                      "-DENABLE_FONTFORGE_EXTRAS=ON",
                      *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
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
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import fontforge; fontforge.font()"
  end
end

__END__
diff --git a/contrib/fonttools/CMakeLists.txt b/contrib/fonttools/CMakeLists.txt
index 0d3f464bc..b9f210cde 100644
--- a/contrib/fonttools/CMakeLists.txt
+++ b/contrib/fonttools/CMakeLists.txt
@@ -18,3 +18,5 @@ target_link_libraries(dewoff PRIVATE ZLIB::ZLIB)
 target_link_libraries(pcl2ttf PRIVATE MathLib::MathLib)
 target_link_libraries(ttf2eps PRIVATE fontforge)
 target_link_libraries(woff PRIVATE ZLIB::ZLIB)
+
+install(TARGETS acorn2sfd dewoff findtable pcl2ttf pfadecrypt rmligamarks showttf stripttc ttf2eps woff RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
