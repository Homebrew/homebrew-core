class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20220308/fontforge-20220308.tar.xz"
  sha256 "01e4017f7a0ccecf436c74b8e1f6b374fc04a5283c1d68967996782e15618e59"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "cc61b2acd794d8434c2fd620be9d01d6211ed66268cb7f1d72103a59b49e7b2b"
    sha256 arm64_big_sur:  "f830bf46889d3abe0c7aa7160b43bde6a3d9bea81decf65123291e9ddb9ec840"
    sha256 monterey:       "c6e089e55e3cdb0879f0f5ccf6d42e9a959d129d83472316cda495b09a5b5259"
    sha256 big_sur:        "0fc1d700fc830ffca7f1e3f644f157e9f5460329c65f470fb5943b496cae1516"
    sha256 catalina:       "9108067b066e00a01944285499e030e215d1237f9948014c9b020bb6f596dc53"
    sha256 x86_64_linux:   "8d08302a7fd0cc8ae7fdaccbda96bcd3184a0fe254c7b7f18d32c6f62498cc7d"
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
