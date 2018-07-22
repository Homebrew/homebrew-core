class Ffmbc < Formula
  desc "FFmpeg customized for broadcast and professional usage"
  homepage "https://code.google.com/p/ffmbc/"
  url "https://drive.google.com/uc?export=download&id=0B0jxxycBojSwTEgtbjRZMXBJREU"
  version "0.7.2"
  sha256 "caaae2570c747077142db34ce33262af0b6d0a505ffbed5c4bdebce685d72e42"
  revision 6

  bottle do
    sha256 "42c6aeb47134046a3aff40034342233f86fe21c834cfba6d35cc0846a79a32d1" => :high_sierra
    sha256 "c6cc044c9ef2a89a5f8ab81e57bc9cb55c0f7a77561188d53b9045c83a5bb5d1" => :sierra
    sha256 "54eb992aee2503bbfdb90ec483ed92a8c3606245692ea587af27f6a6c7af9e41" => :el_capitan
  end

  depends_on "texi2html" => :build
  depends_on "yasm" => :build
  depends_on "faac"
  depends_on "lame"
  depends_on "x264"
  depends_on "xvid"
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "theora" => :optional

  patch :DATA # fix man page generation, fixed in upstream ffmpeg

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-indev=jack",
            "--disable-shared",
            "--enable-gpl",
            "--enable-libfaac",
            "--enable-libmp3lame",
            "--enable-libx264",
            "--enable-libxvid",
            "--enable-nonfree",
            "--cc=#{ENV.cc}"]

    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvorbis" if build.with? "libvorbis"
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
 
