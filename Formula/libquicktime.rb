class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "https://libquicktime.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  revision 3

  bottle do
    sha256 "20531455d4851267e616601cba034fac72193dd7a2436c07d7c0fbf54284ebf1" => :sierra
    sha256 "e6fa7004e86307968977867affb5d9d69f2dedd0e775a785120c20a649fd1e47" => :el_capitan
    sha256 "2bd0006452953d858cb83eb594b9783276102855ffa2bedeea77eed2c94e8927" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "jpeg" => :optional
  depends_on "lame" => :optional
  depends_on "schroedinger" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "libvorbis" => :optional

  # Fixes compilation with ffmpeg 2.x; applied upstream
  # https://sourceforge.net/p/libquicktime/mailman/message/30792767/
  patch :p0 do
    url "https://sourceforge.net/p/libquicktime/mailman/attachment/51812B9E.3090802%40mirriad.com/1/"
    sha256 "ae9773d11db5e60824d4cd8863daa6931e980b7385c595eabc37c7bb8319f225"
  end
  patch :DATA

  # Fix CVE-2016-2399. Applied upstream on March 6th 2017.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-10.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-10.debian.tar.xz"
    sha256 "550cc827c675aeb37727f6daaa311b649246dc9f952e830f0796c25af1137340"
    apply "patches/CVE-2016-2399.patch"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gpl",
                          "--without-doxygen",
                          "--without-x",
                          "--without-gtk"
    system "make"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.m4a")
    output = shell_output("#{bin}/qtinfo #{fixture} 2>&1")
    assert_match "length 1536 samples, compressor mp4a", output
    assert_predicate testpath/".libquicktime_codecs", :exist?
  end
end

__END__
diff --git a/plugins/ffmpeg/audio.c b/plugins/ffmpeg/audio.c
index bc8d750..b185587 100644
--- a/plugins/ffmpeg/audio.c
+++ b/plugins/ffmpeg/audio.c
@@ -515,7 +515,7 @@ static int decode_chunk_vbr(quicktime_t * file, int track)
   if(!chunk_packets)
     return 0;
 
-  new_samples = num_samples + AVCODEC_MAX_AUDIO_FRAME_SIZE / (2 * track_map->channels);
+  new_samples = num_samples + 192000 / (2 * track_map->channels);
   
   if(codec->sample_buffer_alloc <
      codec->sample_buffer_end - codec->sample_buffer_start + new_samples)
@@ -671,7 +671,7 @@ static int decode_chunk(quicktime_t * file, int track)
    */
 
   num_samples += 8192;
-  new_samples = num_samples + AVCODEC_MAX_AUDIO_FRAME_SIZE / (2 * track_map->channels);
+  new_samples = num_samples + 192000 / (2 * track_map->channels);
   
   /* Reallocate sample buffer */
   
