class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz"
  sha256 "3ad0846c92d89ab2e4e6fb83bf991ea677e7aa2ea775845814cbceb608b09843"

  bottle do
    sha256 "a58510833836fc243210b2c3be7ea688697fff59e7ae0c57074c8dcb11544981" => :mojave
    sha256 "26285311d46556224a46a14367dac8c813c3959712c267d591950ae9fb703f38" => :high_sierra
    sha256 "52b4e6e55808d69ff34210337e86359e766c6065da3e43117357d378970cffcf" => :sierra
    sha256 "6cee95b050e52a0f09e2807d6feda1f798d3f43166fbad1e3fb2ec5fe2c11f99" => :el_capitan
    sha256 "8bb05f0875afca69802634411d8e67af5f42e4461b66c640de3c152e049c7843" => :yosemite
    sha256 "d3833fa49709d2857337eebcbd956002f20309cbd676b27070940f84888ebb65" => :mavericks
  end

  head do
    url "svn://svn.mplayerhq.hu/mplayer/trunk"

    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    patch :DATA
  end

  depends_on "yasm" => :build
  depends_on "libcaca" => :optional
  depends_on "libdvdnav" => :optional
  depends_on "pkg-config" => :build if build.with? "libdvdnav"
  depends_on "libdvdread" => :optional

  unless MacOS.prefer_64_bit?
    fails_with :clang do
      build 211
      cause "Inline asm errors during compile on 32bit Snow Leopard."
    end
  end

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
    ]

    args << "--enable-caca" if build.with? "libcaca"
    args << "--enable-dvdnav" if build.with? "libdvdnav"

    if build.with? "libdvdread"
      ENV["LDFLAGS"] = "-L#{Formula["libdvdread"].opt_lib} -ldvdread"
      args << "--enable-dvdread"
    end

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
