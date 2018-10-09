class Ffmbc < Formula
  desc "FFmpeg customized for broadcast and professional usage"
  homepage "https://code.google.com/p/ffmbc/"
  # Original URL is: https://drive.google.com/uc?export=download&id=0B0jxxycBojSwTEgtbjRZMXBJREU
  # whose content is identical to the github link below
  url "https://github.com/darealshinji/ffmbc/archive/v0.7.2.tar.gz"
  sha256 "0a3807160ba0701225bfe9cfcae8fba662990f46932b2eb105e434c751c8944f"
  revision 7

  bottle do
    sha256 "bde01b727ef13b2346619529a7c6f858b188a08934fc88309a830f58eed94693" => :mojave
    sha256 "7877faa373b469dea3b61a17cef5aae2907abd3f89fee6de08813a578703ab5c" => :high_sierra
    sha256 "94303932fccd9e4ba19bbee4f1820e8410c5e5a48047c02ae36f69895a266f34" => :sierra
  end

  depends_on "texi2html" => :build
  depends_on "yasm" => :build
  depends_on "faac"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "theora"
  depends_on "x264"
  depends_on "xvid"

  patch :DATA # fix man page generation, fixed in upstream ffmpeg

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --disable-debug
      --disable-indev=jack
      --disable-shared
      --enable-gpl
      --enable-libfaac
      --enable-libmp3lame
      --enable-libtheora
      --enable-libvorbis
      --enable-libx264
      --enable-libxvid
      --enable-nonfree
    ]

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
 
