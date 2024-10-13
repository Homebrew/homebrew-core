class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.5.tar.xz"
  sha256 "650cd55bb3cb44c9b39ce36dac488428559799c5f18d16d98edb2b7256cbbf85"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later"]
  revision 1

  livecheck do
    url "https://mplayerhq.hu/MPlayer/releases/"
    regex(/href=.*?MPlayer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "4d99950e65cb0275765a4b1c8b0ebfc33723d09d20b009a01751f991af55148e"
    sha256 cellar: :any,                 arm64_sonoma:   "203e6bd9b216cf53d6042de09ed3c4dc1070cd56034279b7eebf3f8f18379b10"
    sha256 cellar: :any,                 arm64_ventura:  "1b17dde1bb0e77e6b994464b92081b3be76df73ab89634c978711c5bb8f4e593"
    sha256 cellar: :any,                 arm64_monterey: "c5516ace4b68e19b4ebcce79ca80ae09bdd7a950054963241333eec4275a80b0"
    sha256 cellar: :any,                 sonoma:         "25f304026cc023e94a49693c47193d3068199cf978d270889fb514f4427495bf"
    sha256 cellar: :any,                 ventura:        "6e159e7274b6c6a461eaf17a9121c97e840a1eeaf93228ee1508d57eed6ad230"
    sha256 cellar: :any,                 monterey:       "ee6ac92f78cb0f428c78f4184ac2e5fb391f6a7cc6083541f3df483bf9a2239e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364ce29a5a68f3ebbcf8dec1f198cfb84e7efb4de60064a06af90babc8ece54d"
  end

  head do
    url "svn://svn.mplayerhq.hu/mplayer/trunk"

    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    patch :DATA
  end

  depends_on "pkg-config" => :build
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
