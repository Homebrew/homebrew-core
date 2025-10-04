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
    sha256 arm64_tahoe:   "204252605683714d5a61ba06de5cd5d85f99c2611d685af671c32ae116647030"
    sha256 arm64_sequoia: "44ec7713b1607ecf66042d6111a44a1bf58e7afb2965c42721857af84ce81deb"
    sha256 arm64_sonoma:  "9785bd774a6e501ac50dacfbce4df93801e2ac799a15e6b8a929d5b35925718a"
    sha256 arm64_ventura: "b8ea24b342d54d613f811190b424ab43e5a2f6504e9596fbbb02a539fa0c73aa"
    sha256 sonoma:        "133c0e66166346d88ab44b32c803381b043614c373236dbca5225fff938391ec"
    sha256 ventura:       "de76dcfa379cd8acb6b9cf407624a30aae1e24884a921c82d8ecbc76ebde17a2"
    sha256 arm64_linux:   "f15a61a1737781ebbacf39d15915e0e6ef03cb01606225b40bde164706935139"
    sha256 x86_64_linux:  "56f9af299864280e57cfa641a177d27b056f8c0dfa4034aaa4ace72e5ebf50f5"
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
