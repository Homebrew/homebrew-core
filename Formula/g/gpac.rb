class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  license "LGPL-2.1-or-later"
  revision 4
  head "https://github.com/gpac/gpac.git", branch: "master"

  stable do
    url "https://github.com/gpac/gpac/archive/refs/tags/v2.4.0.tar.gz"
    sha256 "99c8c994d5364b963d18eff24af2576b38d38b3460df27d451248982ea16157a"

    # Backport fix for macOS 15+ (Sequoia and later)
    patch do # Fixed in v2.5 (not yet released)
      url "https://github.com/gpac/gpac/commit/866784948c02ddfba750999ec212cb206ecc094d.patch?full_index=1"
      sha256 "a7e71a3dcf3daf52faf9f8e9c00e5d9ad2695020f6120f16195c3ffc70598215"
    end

    # Backport fix for the build issues with FFmpeg 7.0+
    patch do # Fixed in v2.5 (not yet released)
      url "https://github.com/gpac/gpac/commit/18863aa2176e423dae2a6d7e39ff6ed6a37b2b78.patch?full_index=1"
      sha256 "c4b4e90f6e42ee977d5f0b4f06a0d04fc2925e9bb2695f1119df8d8a839468cb"
    end

    # Backport fixes for FFmpeg 8.0+ compatibility.
    # These upstream patches don't apply cleanly:
    #   1. https://github.com/gpac/gpac/commit/1bce910fb2409fdfaa67736c1c5ef6a2e89eddc1.patch
    #   2. https://github.com/gpac/gpac/commit/c9a31d0e1b649a30814c6d81c5461859ed63d075.patch
    patch :DATA # Fixed in v2.5 (not yet released)
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbdf9e8ba90e9b978db456626bbfe892ceeb0b48f8931b4f45759be06e91a4e9"
    sha256 cellar: :any,                 arm64_sequoia: "c2901d56f864a0a2b9ae3913626bac8c2f234e13e23e7ccf8e5906c6e4635473"
    sha256 cellar: :any,                 arm64_sonoma:  "82883dfbdcc0eb50c377c76149a112105e7a9d42e1d234812597a523d6880108"
    sha256                               sonoma:        "b515a5123f256d810a2b53f3110ffd4adf1ced2005d4a961c4995135207093c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5dce0bd91c203ce9fb938b4de0909b6ee8d7b54ccb635506816638836c7d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71f8c9e35e72185a39aaf05d12126203e10f7dce1be02e7e7134f8e3b8ec9a2"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libnghttp2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "theora"
  depends_on "xz"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
    depends_on "pulseaudio"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"MP4Box", "-add", test_fixtures("test.mp3"), testpath/"mp4box.mp4"
    assert_path_exists testpath/"mp4box.mp4"

    system bin/"gpac", "-i", test_fixtures("test.mp3"), "-o", testpath/"gpac.mp4"
    assert_path_exists testpath/"gpac.mp4"

    assert_match "ft_font", shell_output("#{bin}/gpac -h modules")
  end
end
__END__
diff --git a/src/filters/ff_avf.c b/src/filters/ff_avf.c
index 1e32720b..5dfe0166 100644
--- a/src/filters/ff_avf.c
+++ b/src/filters/ff_avf.c
@@ -722,9 +722,13 @@ static GF_Err ffavf_process(GF_Filter *filter)
 					memcpy(buffer + j*opid->stride, frame->data[3] + j*frame->linesize[3], opid->width*opid->bpp);
 				}
 			}
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			if (frame->interlaced_frame)
 				gf_filter_pck_set_interlaced(pck, frame->top_field_first ? 1 : 2);
-
+#else
+			if (frame->flags & AV_FRAME_FLAG_INTERLACED)
+				gf_filter_pck_set_interlaced(pck, frame->flags & AV_FRAME_FLAG_TOP_FIELD_FIRST ? 1 : 2);
+#endif
 			gf_filter_pck_set_sap(pck, GF_FILTER_SAP_1);
 			gf_filter_pck_set_cts(pck, frame->pts * opid->tb_num);
 			gf_filter_pck_send(pck);
diff --git a/src/filters/ff_common.c b/src/filters/ff_common.c
index 605abd88..2a4d0b29 100644
--- a/src/filters/ff_common.c
+++ b/src/filters/ff_common.c
@@ -832,7 +832,6 @@ GF_FilterArgs ffmpeg_arg_translate(const struct AVOption *opt)
 		break;
 #if LIBAVCODEC_VERSION_MAJOR >= 57
 	case AV_OPT_TYPE_UINT64:
-//	case AV_OPT_TYPE_UINT:
 		arg.arg_type = GF_PROP_LUINT;
 		sprintf(szDef, LLU, opt->default_val.i64);
 		arg.arg_default_val = gf_strdup(szDef);
@@ -846,6 +845,16 @@ GF_FilterArgs ffmpeg_arg_translate(const struct AVOption *opt)
 		arg.arg_type = GF_PROP_BOOL;
 		arg.arg_default_val = gf_strdup(opt->default_val.i64 ? "true" : "false");
 		break;
+	case AV_OPT_TYPE_UINT:
+		arg.arg_type = GF_PROP_UINT;
+		sprintf(szDef, "%u", (u32) opt->default_val.i64);
+		arg.arg_default_val = gf_strdup(szDef);
+		if (opt->max>=(Double) GF_INT_MAX)
+			sprintf(szDef, "%u-I", (u32) opt->min);
+		else
+			sprintf(szDef, "%u-%u", (u32) opt->min, (u32) opt->max);
+		arg.min_max_enum = gf_strdup(szDef);
+		break;
 #endif
 	case AV_OPT_TYPE_FLOAT:
 		arg.arg_type = GF_PROP_FLOAT;
@@ -922,7 +931,7 @@ GF_FilterArgs ffmpeg_arg_translate(const struct AVOption *opt)
 		break;
 #endif
 	default:
-		GF_LOG(GF_LOG_WARNING, GF_LOG_MEDIA, ("[FFMPEG] Unknown ffmpeg option type %d\n", opt->type));
+		GF_LOG(GF_LOG_WARNING, GF_LOG_MEDIA, ("[FFMPEG] Unknown ffmpeg option type %d\n", type));
 		break;
 	}
 	return arg;
diff --git a/src/filters/ff_dec.c b/src/filters/ff_dec.c
index 6d2fd7ca..b98cc418 100644
--- a/src/filters/ff_dec.c
+++ b/src/filters/ff_dec.c
@@ -535,8 +535,13 @@ restart:
 
 	gf_filter_pck_set_seek_flag(dst_pck, GF_FALSE);
 
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 	if (frame->interlaced_frame)
 		gf_filter_pck_set_interlaced(dst_pck, frame->top_field_first ? 2 : 1);
+#else
+	if (frame->flags & AV_FRAME_FLAG_INTERLACED)
+		gf_filter_pck_set_interlaced(dst_pck, frame->flags & AV_FRAME_FLAG_TOP_FIELD_FIRST ? 2 : 1);
+#endif
 
 	gf_filter_pck_send(dst_pck);
 
diff --git a/src/filters/ff_dmx.c b/src/filters/ff_dmx.c
index fc34177c..2f0db88c 100644
--- a/src/filters/ff_dmx.c
+++ b/src/filters/ff_dmx.c
@@ -1255,9 +1255,15 @@ GF_Err ffdmx_init_common(GF_Filter *filter, GF_FFDemuxCtx *ctx, u32 grab_type)
 		}
 		gf_filter_pid_set_property(pid, GF_PROP_PID_MUX_INDEX, &PROP_UINT(i+1));
 
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 		for (j=0; j<(u32) stream->nb_side_data; j++) {
 			ffdmx_parse_side_data(&stream->side_data[j], pid);
 		}
+#else
+		for (j=0; j<(u32) stream->codecpar->nb_coded_side_data; j++) {
+			ffdmx_parse_side_data(&stream->codecpar->coded_side_data[j], pid);
+		}
+#endif
 
 		if (ctx->demuxer->nb_chapters) {
 			GF_PropertyValue p;
diff --git a/src/filters/ff_enc.c b/src/filters/ff_enc.c
index 06dfff8d..541211f1 100644
--- a/src/filters/ff_enc.c
+++ b/src/filters/ff_enc.c
@@ -588,12 +588,25 @@ static GF_Err ffenc_process_video(GF_Filter *filter, struct _gf_ffenc_ctx *ctx)
 		}
 		if (pck) {
 			ilaced = gf_filter_pck_get_interlaced(pck);
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			if (!ilaced) {
 				ctx->frame->interlaced_frame = 0;
 			} else {
 				ctx->frame->interlaced_frame = 1;
 				ctx->frame->top_field_first = (ilaced==2) ? 1 : 0;
 			}
+#else
+			if (!ilaced) {
+				ctx->frame->flags &= ~AV_FRAME_FLAG_INTERLACED;
+			} else {
+				ctx->frame->flags |= AV_FRAME_FLAG_INTERLACED;
+				if (ilaced==2) {
+					ctx->frame->flags |= AV_FRAME_FLAG_TOP_FIELD_FIRST;
+				} else {
+					ctx->frame->flags &= ~AV_FRAME_FLAG_TOP_FIELD_FIRST;
+				}
+			}
+#endif
 			ctx->frame->pts = ffenc_get_cts(ctx, pck);
 			ctx->frame->_avf_dur = gf_filter_pck_get_duration(pck);
 		}
@@ -706,7 +719,7 @@ static GF_Err ffenc_process_video(GF_Filter *filter, struct _gf_ffenc_ctx *ctx)
 				ctx->reconfig_pending = GF_FALSE;
 				ctx->force_reconfig = GF_FALSE;
 				GF_LOG(GF_LOG_DEBUG, GF_LOG_CODEC, ("[FFEnc] codec flush done, triggering reconfiguration\n"));
-				avcodec_close(ctx->encoder);
+				avcodec_free_context(&ctx->encoder);
 				ctx->encoder = NULL;
 				ctx->setup_failed = 0;
 				e = ffenc_configure_pid_ex(filter, ctx->in_pid, GF_FALSE, GF_TRUE);
diff --git a/src/filters/ff_mx.c b/src/filters/ff_mx.c
index 6c704dce..c727d4ed 100644
--- a/src/filters/ff_mx.c
+++ b/src/filters/ff_mx.c
@@ -1330,7 +1330,14 @@ static GF_Err ffmx_configure_pid(GF_Filter *filter, GF_FilterPid *pid, Bool is_r
 		u8 *data = av_malloc(sizeof(u32) * 9);
 		if (data) {
 			memcpy(data, p->value.uint_list.vals, sizeof(u32)*9);
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			av_stream_add_side_data(st->stream, AV_PKT_DATA_DISPLAYMATRIX, data, 32*9);
+#else
+			av_packet_side_data_add(&st->stream->codecpar->coded_side_data,
+									&st->stream->codecpar->nb_coded_side_data,
+									AV_PKT_DATA_DISPLAYMATRIX,
+									data, 32 * 9, 0);
+#endif
 		}
 	}
 #if (LIBAVCODEC_VERSION_MAJOR>58)
@@ -1340,7 +1347,14 @@ static GF_Err ffmx_configure_pid(GF_Filter *filter, GF_FilterPid *pid, Bool is_r
 		u8 *data = av_malloc(p->value.data.size);
 		if (data) {
 			memcpy(data, p->value.data.ptr, p->value.data.size);
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			av_stream_add_side_data(st->stream, AV_PKT_DATA_ICC_PROFILE, data, p->value.data.size);
+#else
+			av_packet_side_data_add(&st->stream->codecpar->coded_side_data,
+									&st->stream->codecpar->nb_coded_side_data,
+									AV_PKT_DATA_ICC_PROFILE,
+									data, p->value.data.size, 0);
+#endif
 		}
 	}
 	//clli
@@ -1351,7 +1365,14 @@ static GF_Err ffmx_configure_pid(GF_Filter *filter, GF_FilterPid *pid, Bool is_r
 		if (data) {
 			data->MaxCLL = gf_bs_read_u16(bs);
 			data->MaxFALL = gf_bs_read_u16(bs);
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			av_stream_add_side_data(st->stream, AV_PKT_DATA_CONTENT_LIGHT_LEVEL, (u8*) data, sizeof(AVContentLightMetadata));
+#else
+			av_packet_side_data_add(&st->stream->codecpar->coded_side_data,
+									&st->stream->codecpar->nb_coded_side_data,
+									AV_PKT_DATA_CONTENT_LIGHT_LEVEL,
+									(u8*) data, sizeof(AVContentLightMetadata), 0);
+#endif
 		}
 		gf_bs_del(bs);
 	}
@@ -1385,7 +1406,14 @@ static GF_Err ffmx_configure_pid(GF_Filter *filter, GF_FilterPid *pid, Bool is_r
 			data->max_luminance.den = luma_den;
 			data->min_luminance.num = gf_bs_read_u32(bs);
 			data->min_luminance.den = luma_den;
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			av_stream_add_side_data(st->stream, AV_PKT_DATA_MASTERING_DISPLAY_METADATA, (u8*) data, sizeof(AVMasteringDisplayMetadata));
+#else
+			av_packet_side_data_add(&st->stream->codecpar->coded_side_data,
+									&st->stream->codecpar->nb_coded_side_data,
+									AV_PKT_DATA_MASTERING_DISPLAY_METADATA,
+									(u8*) data, sizeof(AVMasteringDisplayMetadata), 0);
+#endif
     	}
     	gf_bs_del(bs);
 	}
@@ -1403,7 +1431,14 @@ static GF_Err ffmx_configure_pid(GF_Filter *filter, GF_FilterPid *pid, Bool is_r
 			data->el_present_flag = gf_bs_read_int(bs, 1);
 			data->bl_present_flag = gf_bs_read_int(bs, 1);
 			data->dv_bl_signal_compatibility_id = gf_bs_read_int(bs, 4);
+#if (LIBAVFORMAT_VERSION_MAJOR < 62)
 			av_stream_add_side_data(st->stream, AV_PKT_DATA_DOVI_CONF, (u8*) data, sizeof(Ref_FFAVDoviRecord));
+#else
+			av_packet_side_data_add(&st->stream->codecpar->coded_side_data,
+									&st->stream->codecpar->nb_coded_side_data,
+									AV_PKT_DATA_DOVI_CONF,
+									(u8*) data, sizeof(Ref_FFAVDoviRecord), 0);
+#endif
 		}
 		gf_bs_del(bs);
 	}
