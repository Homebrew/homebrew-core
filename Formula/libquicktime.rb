class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "https://libquicktime.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libquicktime/libquicktime/1.2.4/libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  revision 4

  bottle do
    sha256 "f507d898a0237474e45a9780d08113887e00ddd6ae35934bbac4ef4e65d58dca" => :high_sierra
    sha256 "9256a6709e81af34e6ad4655436fc533a30471c0ea06a18805c38ab2e086e510" => :sierra
    sha256 "9a98dacafd9b7be723a9549d4b51709495ab1d3cbf4b1b1c8837045a99735d31" => :el_capitan
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
  # Also, fixes from upstream for CVE-2017-9122 through CVE-2017-9128, applied
  # by Debian since 30 Jun 2017.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-11.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libq/libquicktime/libquicktime_1.2.4-11.debian.tar.xz"
    sha256 "3f655fdab37fcad2d2e7d20672ff8bad6eec64a9d5a7dc702c79082346ba878b"
    apply "patches/CVE-2016-2399.patch"
    apply "patches/CVE-2017-9122_et_al.patch"
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
   
