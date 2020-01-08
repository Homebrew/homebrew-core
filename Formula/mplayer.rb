class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.xz"
  sha256 "82596ed558478d28248c7bc3828eb09e6948c099bbd76bb7ee745a0e3275b548"

  bottle do
    cellar :any
    sha256 "d46c9afd22fbdda5423877d2583732e6c88ee9bd52b26c8b79ea8e90c9af7d59" => :catalina
    sha256 "72da2446b0077085121da3cc3437a3e07d0bd2136529dd7dfba79d05bca1b405" => :mojave
    sha256 "11c01635f619e3aa77a85cd095be0b302d2b25fdd4362f47340c93122a113775" => :high_sierra
    sha256 "225e2628b4edf16a4ffea768e03587a8cc1c3f67544c92cb3fb8f3332feee51d" => :sierra
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
