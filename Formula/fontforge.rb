class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20220308/fontforge-20220308.tar.xz"
  sha256 "01e4017f7a0ccecf436c74b8e1f6b374fc04a5283c1d68967996782e15618e59"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2877b10547ba4cd29f862f6c1dc1c309d77160cd5f2c77579e293b2384fafeed"
    sha256 arm64_monterey: "c4c7c43b312119d9b97d42ebaa210697568cf22ce82498cf8813e5ec58ab37b0"
    sha256 arm64_big_sur:  "eb069fa8949ad7af2695a89274759db5cb38e98e9bcc23fdf30c7de72a9d6d53"
    sha256 ventura:        "03acf1f910c8092b29c06f8c4f893ddec0902b4bcebe4dbe7172fb7d3e2449a7"
    sha256 monterey:       "44b3d610d061ef7fe534c2987335139d66864bafef53a3e7ba49cb84aa1275e5"
    sha256 big_sur:        "228b244c5aaea2c32509766bff600123517f2f2a8237c55777c4330cb2172ca9"
    sha256 catalina:       "de84a69c165f80517bdf2a20de3449ffb15e8ca17d02d4f5e7d3dfd7a298b32c"
    sha256 x86_64_linux:   "4cb6042dc8bce77449063f59bce4e9fb886508e3f0cef6ca5e46e68f29a9c17b"
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
  depends_on "python@3.10"
  depends_on "readline"
  depends_on "woff2"

  uses_from_macos "libxml2"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/fontforge/fontforge/1346ce6e4c004c312589fdb67e31d4b2c32a1656/tests/fonts/Ambrosia.sfd"
    sha256 "6a22acf6be4ab9e5c5a3373dc878030b4b8dc4652323395388abe43679ceba81"
  end

  # Fix for rpath on ARM
  # https://github.com/fontforge/fontforge/issues/4658
  patch :DATA

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
    system bin/"fontforge", "-version"
    system bin/"fontforge", "-lang=py", "-c", "import fontforge; fontforge.font()"
    system "python3.10", "-c", "import fontforge; fontforge.font()"

    resource("homebrew-testdata").stage do
      ffscript = "fontforge.open('Ambrosia.sfd').generate('#{testpath}/Ambrosia.woff2')"
      system bin/"fontforge", "-c", ffscript
    end
    assert_predicate testpath/"Ambrosia.woff2", :exist?

    fileres = shell_output("/usr/bin/file #{testpath}/Ambrosia.woff2")
    assert_match "Web Open Font Format (Version 2)", fileres
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
