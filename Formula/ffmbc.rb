class Ffmbc < Formula
  desc "FFmpeg customized for broadcast and professional usage"
  homepage "https://code.google.com/p/ffmbc/"
  url "https://drive.google.com/uc?export=download&id=0B0jxxycBojSwTEgtbjRZMXBJREU"
  version "0.7.2"
  sha256 "caaae2570c747077142db34ce33262af0b6d0a505ffbed5c4bdebce685d72e42"
  revision 4

  bottle do
    sha256 "93018afba1f0661d6e6a539b189eea0692932a7af0a30b4c81aebadc79332657" => :high_sierra
    sha256 "5923eee01026353f52122bdc3576a94da1d0315a1838cb19d20af07f66ec9566" => :sierra
    sha256 "118b7d823df82d0b9eb27544dfe0246f8119aac8f48431e814119448dc47b936" => :el_capitan
  end

  option "without-x264", "Disable H.264 encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion
  depends_on "yasm" => :build

  depends_on "x264" => :recommended
  depends_on "faac" => :recommended
  depends_on "lame" => :recommended
  depends_on "xvid" => :recommended

  depends_on "freetype" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libogg" => :optional
  depends_on "libvpx" => :optional

  patch :DATA # fix man page generation, fixed in upstream ffmpeg

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-shared",
            "--enable-gpl",
            "--enable-nonfree",
            "--cc=#{ENV.cc}"]

    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libxvid" if build.with? "xvid"

    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libogg" if build.with? "libogg"
    args << "--enable-libvpx" if build.with? "libvpx"

    system "./configure", *args
    system "make"

    # ffmbc's lib and bin names conflict with ffmpeg and libav
    # This formula will only install the commandline tools
    mv "ffprobe", "ffprobe-bc"
    mv "doc/ffprobe.1", "doc/ffprobe-bc.1"
    bin.install "ffmbc", "ffprobe-bc"
    man.mkpath
    man1.install "doc/ffmbc.1", "doc/ffprobe-bc.1"
  end

  def caveats
    <<~EOS
      Due to naming conflicts with other FFmpeg forks, this formula installs
      only static binaries - no shared libraries are built.

      The `ffprobe` program has been renamed to `ffprobe-bc` to avoid name
      conflicts with the FFmpeg executable of the same name.
    EOS
  end

  test do
    system "#{bin}/ffmbc", "-h"
  end
end

__END__
diff --git a/doc/texi2pod.pl b/doc/texi2pod.pl
index 18531be..88b0a3f 100755
--- a/doc/texi2pod.pl
+++ b/doc/texi2pod.pl
@@ -297,6 +297,8 @@ $inf = pop @instack;
 
 die "No filename or title\n" unless defined $fn && defined $tl;
 
+print "=encoding utf8\n\n";
+
 $sects{NAME} = "$fn \- $tl\n";
 $sects{FOOTNOTES} .= "=back\n" if exists $sects{FOOTNOTES};
 
