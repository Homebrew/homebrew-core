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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7d050d5dcac278c608d5a152c95accda9294389636b902ef2f6267298d42c8da"
    sha256 cellar: :any,                 arm64_monterey: "79154ab80a76e3ffe7346287c18480cc9762acdf638a520ac2f0610f1580406e"
    sha256 cellar: :any,                 arm64_big_sur:  "caaee4a430194ac3e9f942c06390b92c505d7e01eb2345df067e6cd3fe44c477"
    sha256 cellar: :any,                 ventura:        "af54e0730489194bc2152761cbc244f7028a548c0b8d935ed2fe7e2446a73475"
    sha256 cellar: :any,                 monterey:       "dfadfbf16c6f85e94145fa4c6f9333124ced9749744f68cb6f41ea34be422872"
    sha256 cellar: :any,                 big_sur:        "c0b675e5aeb8354a52b73f12f22a47ed77ee765737a558280c2f9d80e388c398"
    sha256 cellar: :any,                 catalina:       "ba3e8faff3e50f9d85d1b4ff0e28047883f9ad86e502c249ecc7be482d5f22bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897462e9d760c8737c08878e1dbbf8afec17c9dfec0fc09d2992e4f56a5e935d"
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

  uses_from_macos "libxml2"

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
