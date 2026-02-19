class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.5.tar.xz"
  sha256 "650cd55bb3cb44c9b39ce36dac488428559799c5f18d16d98edb2b7256cbbf85"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later"]
  revision 2

  livecheck do
    url "https://mplayerhq.hu/MPlayer/releases/"
    regex(/href=.*?MPlayer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1d27bc5e20a020dfc9cbda188a2d8af4cb54203b3a29bf97205ec5ba5c15038c"
    sha256 cellar: :any,                 arm64_sequoia: "5acd5d7ebed8bc44b0aff0360bf20ec76cfb1a732349f8ece45bf84517db0b47"
    sha256 cellar: :any,                 arm64_sonoma:  "c6dee8142133e094cff65c33b6b3aa7ca538e977dedd89e903d6a323460715d7"
    sha256 cellar: :any,                 sonoma:        "5f089d84929885e170a96efba53a2f48adca16fcba31fccabf7efc9ed29f14f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a9bf7aa318aebb060bf0ef17d93ed5f335d79f7e2a56f2d3181755216c9ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fe472a2eaa853dea397a8cf67c22788a961d4edd3723f96bf3d439003ee1bc3"
  end

  head do
    url "svn://svn.mplayerhq.hu/mplayer/trunk"

    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    patch :DATA
  end

  depends_on "pkgconf" => :build
  depends_on "yasm" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libcaca"
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around build failure with newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-int-conversion -Wno-incompatible-function-pointer-types"
    end

    # Fix x86_64 detection used to apply a workaround.
    # TODO: Remove on the next release as code was removed.
    # Issue ref: https://trac.mplayerhq.hu/ticket/2383
    inreplace "libvo/osx_objc_common.m", " defined(x86_64)", " defined(__x86_64__)" if build.stable?

    # we disable cdparanoia because homebrew's version is hacked to work on macOS
    # and mplayer doesn't expect the hacks we apply. So it chokes. Only relevant
    # if you have cdparanoia installed.
    # Specify our compiler to stop ffmpeg from defaulting to gcc.
    args = %W[
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-cdparanoia
      --prefix=#{prefix}
      --disable-x11
      --enable-caca
      --enable-freetype
      --disable-libbs2b
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end

__END__
diff --git a/configure b/configure
index addc461..3b871aa 100755
--- a/configure
+++ b/configure
@@ -1517,8 +1517,6 @@ if test -e ffmpeg/mp_auto_pull ; then
 fi

 if test "$ffmpeg_a" != "no" && ! test -e ffmpeg ; then
-    echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-    read tmp
     if ! git clone -b $FFBRANCH --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg ; then
         rm -rf ffmpeg
         echo "Failed to get a FFmpeg checkout"
