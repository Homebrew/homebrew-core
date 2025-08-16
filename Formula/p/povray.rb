class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  license "AGPL-3.0-or-later"
  revision 14
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  stable do
    url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
    sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"

    on_sequoia :or_newer do
      # Apply FreeBSD patches for libc++ >= 19 needed in Xcode 16.3
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6133473e4227abbfcf023bea6ab5eeed9c17e55b/graphics/povray37/files/patch-vfe_vfe.cpp"
        sha256 "81e6ad64dadce1581cbab3be9774d5a5c22307e8738ee1452eb7e4d3e5a7e234"
      end
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6133473e4227abbfcf023bea6ab5eeed9c17e55b/graphics/povray37/files/patch-vfe_vfeconf.h"
        sha256 "8e2246c5ded770b0fe835ae062aca44e98fc220314e39ba6c068ed7f270b71b2"
      end

      # Workaround for Xcode 16.3+, issue ref: https://github.com/POV-Ray/povray/issues/479
      patch :DATA
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "a43f64589b9b2abbc3dd1460e56c79c0d8473e0b0cdd343f7fae52474450adc9"
    sha256 arm64_sonoma:  "ffc8acf31801cc124cf903e3ad6014014e6f5e3784938b43f42bcb39758d3f95"
    sha256 arm64_ventura: "e3b9af45cf02e6e071dac8e9e15681a727817ceb26e21400dd2f10c4c161211e"
    sha256 sonoma:        "d43346c84ebe723c8099104abe49b6d28850f4597ef07a0be97bf5af616c6384"
    sha256 ventura:       "bda46d7ccad80bb6488dac7d09fecc8214ff19bd39c267fbc143cb846d4d2882"
    sha256 arm64_linux:   "4a6efde256e0f9880d0eef16f7f3f7a70208e751a353313f687040e100a3449c"
    sha256 x86_64_linux:  "757f8971fcd168f2eedea18303542b1566eaf0308fbcee6833de2aa4b11bdc31"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # See https://github.com/freebsd/freebsd-ports/commit/6133473e4227abbfcf023bea6ab5eeed9c17e55b
    if OS.mac? && MacOS.version >= :sequoia
      ENV.append "CPPFLAGS", "-DPOVMSUCS2=char16_t -DUCS2=char16_t -DUCS4=char32_t"
    end

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openexr=#{Formula["openexr"].opt_prefix}
      --without-libsdl
      --without-x
    ]

    # Adjust some scripts to search for `etc` in HOMEBREW_PREFIX.
    %w[allanim allscene portfolio].each do |script|
      inreplace "unix/scripts/#{script}.sh",
                /^DEFAULT_DIR=.*$/, "DEFAULT_DIR=#{HOMEBREW_PREFIX}"
    end

    cd "unix" do
      system "./prebuild.sh"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Condensed version of `share/povray-3.7/scripts/allscene.sh` that only
    # renders variants of the famous Utah teapot as a quick smoke test.
    scenes = share.glob("povray-3.7/scenes/advanced/teapot/*.pov")
    refute_empty scenes, "Failed to find test scenes."
    scenes.each do |scene|
      system share/"povray-3.7/scripts/render_scene.sh", ".", scene
    end
  end
end

__END__
diff --git a/source/backend/shape/truetype.cpp b/source/backend/shape/truetype.cpp
index 7e27ccc3..80ab047c 100644
--- a/source/backend/shape/truetype.cpp
+++ b/source/backend/shape/truetype.cpp
@@ -117,7 +117,7 @@ typedef unsigned int ULONG;
 typedef short FWord;
 typedef unsigned short uFWord;
 
-#if !defined(TARGET_OS_MAC)
+#if !defined(__MACTYPES__)
 typedef int Fixed;
 #endif
