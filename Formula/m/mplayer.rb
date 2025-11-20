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
    sha256 cellar: :any,                 arm64_tahoe:   "65274400f1b0e7ead48b8ea7c5b17b1e7f14d7f826e6e9f0db18f177b199c9a7"
    sha256 cellar: :any,                 arm64_sequoia: "b5b83382af26c00721f3c592f665632510acb2b8e2e392da2960bf888c3a5d7d"
    sha256 cellar: :any,                 arm64_sonoma:  "0ce6193aca1ab3fd60830eab3056077798a914bb5d1e091b25a9a6e6ffa860b8"
    sha256 cellar: :any,                 sonoma:        "c3de6bdfb89c6ddaae79383c1599bd1da35a637c3c9f53e450429f33a5b5ef51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6b437e842eaab0196c05823d0a3d662ccc521db89c90c131b826b1cf4d9a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2069ea96f8e706d6feba320f19ed419b02007caf4080e8f8edbfd7826e4fe938"
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
  uses_from_macos "zlib"

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
