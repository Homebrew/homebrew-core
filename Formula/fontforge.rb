class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20201107/fontforge-20201107.tar.xz"
  sha256 "68bcba8f602819eddc29cd356ee13fafbad7a80d19b652d354c6791343476c78"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "96975c5c015c165eb5910588c295ea62434063ff468b477ac3d11e77735609f7"
    sha256 arm64_big_sur:  "240744fcd44612d9208c1f47e81d8f01b9d94108b50afe54170be14329a95a5a"
    sha256 monterey:       "3deb4786174659e76b9988079f7ef56b42deb3952ea67b13e5fcbafb553b127d"
    sha256 big_sur:        "20f92c9d7e6405ca51bdf9f9a2f0216b527bd78e38c2c3bedecbfab3eeb12747"
    sha256 catalina:       "de48bd3b27ae91d21b8f7d8724cf2b9100683bf02db99794bcd9d9c4ca3483de"
    sha256 mojave:         "fc6b9c92f02f1e01d8850bfb595dad4f18faf2c3ba079d7bf8084699ec006d53"
    sha256 x86_64_linux:   "5377794ced753c4220bfa33f5064b3b041819fe264d09b785e8138703a7e0812"
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
