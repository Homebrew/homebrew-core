class Fontforge < Formula
  desc "Command-line outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20230101/fontforge-20230101.tar.xz"
  sha256 "ca82ec4c060c4dda70ace5478a41b5e7b95eb035fe1c4cf85c48f996d35c60f8"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/fontforge/fontforge.git", branch: "master"

  bottle do
    rebuild 3
    sha256 arm64_sequoia: "c847e100b5a96a03d1c09119a24141b63714eabe9a6c5228be66c620a089283e"
    sha256 arm64_sonoma:  "52e4ee7c9795fcd5d0a78f8e1af5d0fa3d6359ed17a44776882713961c984e64"
    sha256 arm64_ventura: "7407da2b13369840b2a560717591af390cce5251a1fa676aab13402d05f2ef9e"
    sha256 sonoma:        "6581ae0f6cf1c1cbbda62250b2711da937baaa463df83c2a53ac58f366601cdf"
    sha256 ventura:       "29c86e972e84fa5bc6ae2a98f2a5ebc324037950da146b5d486159996100b12c"
    sha256 x86_64_linux:  "ca389200fda1b853af47605d84eaff5a4ee72273f38964fd83aa2ed8b639610e"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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

  # Replace distutils for python 3.12+: https://github.com/fontforge/fontforge/pull/5423
  patch :DATA

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

    python = Formula["python@3.13"].opt_bin/"python3.13"
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

__END__
diff --git a/pyhook/CMakeLists.txt b/pyhook/CMakeLists.txt
index dd48054..53708f1 100644
--- a/pyhook/CMakeLists.txt
+++ b/pyhook/CMakeLists.txt
@@ -20,8 +20,11 @@ target_link_libraries(psMat_pyhook PRIVATE Python3::Module)
 # FindPython3 provides Python3_SITEARCH, but this is an absolute path
 # So do it ourselves, getting the prefix-relative path instead
 if(NOT DEFINED PYHOOK_INSTALL_DIR)
+  if(APPLE)
+    set(_PYHOOK_SYSCONFIG_PREFIX " 'posix_prefix',")
+  endif()
   execute_process(
-    COMMAND "${Python3_EXECUTABLE}" -c "import distutils.sysconfig as sc; print(sc.get_python_lib(prefix='', plat_specific=True,standard_lib=False))"
+    COMMAND "${Python3_EXECUTABLE}" -c "import sysconfig as sc; print(sc.get_path('platlib',${_PYHOOK_SYSCONFIG_PREFIX} vars={'platbase': '.'}))"
     RESULT_VARIABLE _pyhook_install_dir_result
     OUTPUT_VARIABLE PYHOOK_INSTALL_DIR
     OUTPUT_STRIP_TRAILING_WHITESPACE)
