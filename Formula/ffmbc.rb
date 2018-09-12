class Ffmbc < Formula
  desc "FFmpeg customized for broadcast and professional usage"
  homepage "https://code.google.com/p/ffmbc/"
  # Original URL is: https://drive.google.com/uc?export=download&id=0B0jxxycBojSwTEgtbjRZMXBJREU
  # whose content is identical to the github link below
  url "https://github.com/darealshinji/ffmbc/archive/v0.7.2.tar.gz"
  sha256 "0a3807160ba0701225bfe9cfcae8fba662990f46932b2eb105e434c751c8944f"
  revision 6

  bottle do
    rebuild 1
    sha256 "95c4ebf8d5238e8132ab35d38fb0aad2f396b09c9d660b7fe66bf382910aca80" => :mojave
    sha256 "d525df984f61f4cf2bcfe4e12f5bd359df62dfab089e27735d306493858bfb3c" => :high_sierra
    sha256 "a17fe2130459a08d60f1a3d6500fc985a5a8e690e066568a077ee0517c2fac5e" => :sierra
    sha256 "eece8d408f06084a98fd0ab6ff55d99aaa5a5f38db6d5a0b04f48ddf2f4f1e65" => :el_capitan
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
 
