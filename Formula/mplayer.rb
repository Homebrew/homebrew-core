class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.5.tar.xz"
  sha256 "650cd55bb3cb44c9b39ce36dac488428559799c5f18d16d98edb2b7256cbbf85"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later"]

  livecheck do
    url "https://mplayerhq.hu/MPlayer/releases/"
    regex(/href=.*?MPlayer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c5f82232990e06050b98b5a7b03c8ad6b5f254a5835e4f481ebe75c021c008f"
    sha256 cellar: :any,                 arm64_big_sur:  "342506fa732f2c986f49ff9dbab695a099c4e5b245400488a22a278dcea57253"
    sha256 cellar: :any,                 monterey:       "00103327d3942df72a98315701f7e85ad2efa4117523b68740b7027dcc1682e2"
    sha256 cellar: :any,                 big_sur:        "3b5339dbcd0b5bb06748cb16aed789fc24502e4f19947c0ec328f8d57a9f53c2"
    sha256 cellar: :any,                 catalina:       "e899927dc7566ac3f3157e1f82b2786a2471443537ae6dbe73b9ef38d27b2630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd55b355fbcb3fe9848921430f12bc2c2bb17c2d1f39eccea909e0ec496781e"
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
