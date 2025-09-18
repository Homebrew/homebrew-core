class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/refs/tags/3.0.4.tar.gz"
  sha256 "76589f02d1640fc5063d48a47f017077c6b7557431221defe9e38679d86d4db8"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/kallisti5/huexpress.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "0e4ce00990799c34600701c248f3cf8b2e8ed560b58b8616bd63aafdc2fe3f2f"
    sha256 cellar: :any, arm64_sequoia:  "c72017994c148e0c3320a90bcadb956732c96b544def28ff398892e578922c22"
    sha256 cellar: :any, arm64_sonoma:   "6e8a501836cd6c97ee3344adaff36f6be40a2ddd6d3266cb980cb32eab566006"
    sha256 cellar: :any, arm64_ventura:  "d69fc8ce360f304a6c9e95a8120196d5efaec9f77f02a82b0e5c3e4cab6b84da"
    sha256 cellar: :any, arm64_monterey: "a0919bd5024f7f197c262f0ba1dd5c57871506308bd7a4bfd98b5f18f04dbb50"
    sha256 cellar: :any, arm64_big_sur:  "2709e20246d6ab1a14329ccc842e49eefd9276c6b1e3ef90bcadc85c2213a394"
    sha256 cellar: :any, sonoma:         "ed758b69740bc72b5bdb5d463bea32d699c5f5e6d2de07ebfec1a035cebe6dd0"
    sha256 cellar: :any, ventura:        "3fc6ef796681ae0b49b2f6386add406c8ace5aa450160b2530fe0174205d6b7e"
    sha256 cellar: :any, monterey:       "5c02e7de59a65392f1347c65df445e2d447daaac2eb508c920f8ce452628dbd5"
    sha256 cellar: :any, big_sur:        "37272d08ed74984450ae2f08e17e9b41fdf32cc487aee1c0ab0832c10177474a"
    sha256 cellar: :any, catalina:       "9e714566437e60a45c978daeade8dbb3515ee37c5d2b6de1a203443f243917d8"
    sha256               arm64_linux:    "cf8c9ea08ea0615c32f11b3b2574054bc950436bca1539c7c7d0625c1a7fd3ec"
    sha256               x86_64_linux:   "8f5ca6b63b8fc347e8221765dc09ac1000f4b6a62e53424fb578bb14103c8952"
  end

  depends_on "pkgconf" => :build
  depends_on "scons" => :build
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Workaround for newer Clang
  # upstream bug report, https://github.com/kallisti5/huexpress/issues/19
  patch :DATA

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `XBuf'; src/osd_sdl_machine.o:../src/osd_sdl_machine.c:13: first defined here
    # upstream bug report, https://github.com/kallisti5/huexpress/issues/18
    ENV.append "CC", "-fcommon" if OS.linux?

    # Don't statically link to libzip.
    inreplace "src/SConscript", "pkg-config --cflags --libs --static libzip", "pkg-config --cflags --libs libzip"
    system "scons"
    bin.install ["src/huexpress", "src/hucrc"]
  end

  test do
    assert_match(/Version #{version}$/, shell_output("#{bin}/huexpress -h", 1))
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index 096a1ef..98216b9 100644
--- a/SConstruct
+++ b/SConstruct
@@ -40,5 +40,12 @@ env.Append(CPPDEFINES={'VERSION_MAJOR' : '3'})
 env.Append(CPPDEFINES={'VERSION_MINOR' : '0'})
 env.Append(CPPDEFINES={'VERSION_UPDATE' : '4'})
 
+# Workaround for newer Clang
+clang_version = env['CCVERSION']
+if env['PLATFORM'] == 'darwin' and 'clang' in env['CC']:
+    clang_version_parts = [int(part) for part in clang_version.split('.')]
+    if clang_version_parts >= [15, 0, 0]:
+        env.Append(CFLAGS=['-Wno-incompatible-function-pointer-types', '-Wno-int-conversion'])  # Pass as separate flags
+
 Export("env")
 SConscript('src/SConscript')
