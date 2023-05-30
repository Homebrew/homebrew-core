class Mplayer < Formula
  desc "UNIX movie player"
  homepage "https://mplayerhq.hu/"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later"]
  revision 1
  head "svn://svn.mplayerhq.hu/mplayer/trunk"

  stable do
    url "https://mplayerhq.hu/MPlayer/releases/MPlayer-1.5.tar.xz"
    sha256 "650cd55bb3cb44c9b39ce36dac488428559799c5f18d16d98edb2b7256cbbf85"

    # Backports to fix build with FFmpeg 6:
    # - r38361 (configure, av_helpers.c: Fix compilation against latest FFmpeg) to fix:
    #   av_helpers.c:57:34: error: no member named 'decode' in 'struct AVCodec'
    # - r38411 (ad_spdif.c: Use proper way to set avformat option) to fix:
    #   libmpcodecs/ad_spdif.c:115:57: error: no member named 'priv_data_size' in 'struct AVOutputFormat'
    patch :p0, :DATA
  end

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

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libcaca"

  uses_from_macos "libxml2"

  def install
    # Remove bundled FFmpeg
    (buildpath/"ffmpeg").rmtree if build.stable?

    # we disable cdparanoia because homebrew's version is hacked to work on macOS
    # and mplayer doesn't expect the hacks we apply. So it chokes. Only relevant
    # if you have cdparanoia installed.
    # Specify our compiler to stop ffmpeg from defaulting to gcc.
    args = %W[
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --prefix=#{prefix}
      --confdir=#{pkgetc}
      --disable-cdparanoia
      --disable-ffmpeg_a
      --disable-libbs2b
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
Index: av_helpers.c
===================================================================
--- av_helpers.c	(revision 38360)
+++ av_helpers.c	(revision 38361)
@@ -51,11 +51,9 @@
             AVCodecContext *s= ptr;
             if(s->codec){
                 if(s->codec->type == AVMEDIA_TYPE_AUDIO){
-                    if(s->codec->decode)
-                        type= MSGT_DECAUDIO;
+                    type= MSGT_DECAUDIO;
                 }else if(s->codec->type == AVMEDIA_TYPE_VIDEO){
-                    if(s->codec->decode)
-                        type= MSGT_DECVIDEO;
+                    type= MSGT_DECVIDEO;
                 }
                 //FIXME subtitles, encoders (what msgt for them? there is no appropriate ...)
             }
Index: configure
===================================================================
--- configure	(revision 38360)
+++ configure	(revision 38361)
@@ -1591,8 +1591,8 @@
 }

 echocheck "ffmpeg/libavcodec/allcodecs.c"
-libavdecoders_all=$(list_subparts_extern  AVCodec       decoder  codec/allcodecs.c)
-libavencoders_all=$(list_subparts_extern  AVCodec       encoder  codec/allcodecs.c)
+libavdecoders_all=$(list_subparts_extern  FFCodec       decoder  codec/allcodecs.c)
+libavencoders_all=$(list_subparts_extern  FFCodec       encoder  codec/allcodecs.c)
 libavparsers_all=$(list_subparts_extern   AVCodecParser parser   codec/parsers.c)
 test $? -eq 0 && _list_subparts=found || _list_subparts="not found"
 echores "$_list_subparts"
@@ -1610,7 +1610,7 @@
 echores "$_list_subparts"

 echocheck "ffmpeg/libavcodec/bitsteram_filters.c"
-libavbsfs_all=$(list_subparts_extern AVBitStreamFilter bsf codec/bitstream_filters.c)
+libavbsfs_all=$(list_subparts_extern FFBitStreamFilter bsf codec/bitstream_filters.c)
 test $? -eq 0 && _list_subparts_extern=found || _list_subparts_extern="not found"
 echores "$_list_subparts_extern"

@@ -9812,9 +9812,9 @@
     cp $TMPH ffmpeg/$file
 }

-print_enabled_components libavcodec/codec_list.c AVCodec codec_list $libavdecoders $libavencoders
+print_enabled_components libavcodec/codec_list.c FFCodec codec_list $libavdecoders $libavencoders
 print_enabled_components libavcodec/parser_list.c AVCodecParser parser_list $libavparsers
-print_enabled_components libavcodec/bsf_list.c AVBitStreamFilter bitstream_filters $libavbsfs
+print_enabled_components libavcodec/bsf_list.c FFBitStreamFilter bitstream_filters $libavbsfs
 print_enabled_components libavdevice/indev_list.c AVInputFormat indev_list ""
 print_enabled_components libavdevice/outdev_list.c AVOutputFormat outdev_list ""
 print_enabled_components libavformat/demuxer_list.c AVInputFormat demuxer_list $libavdemuxers
Index: libmpcodecs/ad_spdif.c
===================================================================
--- libmpcodecs/ad_spdif.c	(revision 38410)
+++ libmpcodecs/ad_spdif.c	(revision 38411)
@@ -79,7 +79,7 @@
 
 static int init(sh_audio_t *sh)
 {
-    int i, x, in_size, srate, bps, *dtshd_rate, res;
+    int i, x, in_size, srate, bps, res;
     unsigned char *start;
     double pts;
     static const struct {
@@ -97,6 +97,7 @@
     AVStream            *stream    = NULL;
     const AVOption      *opt       = NULL;
     struct spdifContext *spdif_ctx = NULL;
+    AVDictionary *opts = NULL;
 
     spdif_ctx = av_mallocz(sizeof(*spdif_ctx));
     if (!spdif_ctx)
@@ -112,9 +113,6 @@
     lavf_ctx->oformat = av_guess_format(FILENAME_SPDIFENC, NULL, NULL);
     if (!lavf_ctx->oformat)
         goto fail;
-    lavf_ctx->priv_data = av_mallocz(lavf_ctx->oformat->priv_data_size);
-    if (!lavf_ctx->priv_data)
-        goto fail;
     lavf_ctx->pb = avio_alloc_context(spdif_ctx->pb_buffer, OUTBUF_SIZE, 1, spdif_ctx,
                             read_packet, write_packet, seek);
     if (!lavf_ctx->pb)
@@ -130,12 +128,17 @@
             break;
         }
     }
-    if ((res = avformat_write_header(lavf_ctx, NULL)) < 0) {
+    // FORCE USE DTS-HD
+    if (lavf_ctx->streams[0]->codecpar->codec_id == AV_CODEC_ID_DTS)
+        av_dict_set(&opts, "dtshd_rate", "768000" /* 192000*4 */, 0);
+    if ((res = avformat_write_header(lavf_ctx, opts)) < 0) {
+        av_dict_free(&opts);
         if (res == AVERROR_PATCHWELCOME)
             mp_msg(MSGT_DECAUDIO,MSGL_INFO,
                "This codec is not supported by spdifenc.\n");
         goto fail;
     }
+    av_dict_free(&opts);
     spdif_ctx->header_written = 1;
 
     // get sample_rate & bitrate from parser
@@ -177,13 +180,6 @@
         sh->i_bps                       = bps;
         break;
     case AV_CODEC_ID_DTS: // FORCE USE DTS-HD
-        opt = av_opt_find(&lavf_ctx->oformat->priv_class,
-                          "dtshd_rate", NULL, 0, 0);
-        if (!opt)
-            goto fail;
-        dtshd_rate                      = (int*)(((uint8_t*)lavf_ctx->priv_data) +
-                                          opt->offset);
-        *dtshd_rate                     = 192000*4;
         spdif_ctx->iec61937_packet_size = 32768;
         sh->sample_format               = AF_FORMAT_IEC61937_LE;
         sh->samplerate                  = 192000; // DTS core require 48000
