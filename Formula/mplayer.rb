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
    sha256 cellar: :any,                 arm64_monterey: "990f18527e83dddb5c93b7dbf3ebc57b58e8f75e06f3c8bc192fafae0f2ceb4a"
    sha256 cellar: :any,                 arm64_big_sur:  "d6f924fc2e95ae087a3614edee922fc72fd49aa2d2052593f8035841b8b77356"
    sha256 cellar: :any,                 monterey:       "bdea6626f7acb3fc1e82394302084dd9b69590775729de0c6a1197415fa1ef7f"
    sha256 cellar: :any,                 big_sur:        "8998319dfcc43ea2bff8cd11b9d169be0c95562646c1eea3f533468a31ef6a79"
    sha256 cellar: :any,                 catalina:       "0a4a3b3373a86d490192e55ad5a611bc00559185cc619d5ed3f15f66530bae72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d487630a4dd8aa8a8c4c89b785c6c0ec7e40ef3eb1e3a989fae27b6c484b43"
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

  def install
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
    system "#{bin}/mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
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
