class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.xz"
  sha256 "82596ed558478d28248c7bc3828eb09e6948c099bbd76bb7ee745a0e3275b548"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later"]
  revision 2

  livecheck do
    url "https://mplayerhq.hu/MPlayer/releases/"
    regex(/href=.*?MPlayer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "5e7407733e35bf8ec46946effb64630c6530bfb4a8441aa4322fd5dea4a8b1e1"
    sha256 cellar: :any,                 big_sur:      "7482460cff2275c11a9a0249bd77b018a211d926cc2fde68912e1063b2769dbd"
    sha256 cellar: :any,                 catalina:     "cbbbc082ba6ceb67c119d97a4ecce0c2af5f7e19668e4361093e761cd981a6a6"
    sha256 cellar: :any,                 mojave:       "2ee069c78251cc7e45bd3c1b6bd5941e927b01f43af5f6deeb4fcdd744dbc52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7f9423624070d5446b50c0770e8afefadf7283322eb5c83a2cb96d25d4cc8531"
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
