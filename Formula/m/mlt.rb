class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1-only"
  revision 3
  head "https://github.com/mltframework/mlt.git", branch: "master"

  stable do
    url "https://github.com/mltframework/mlt/releases/download/v7.32.0/mlt-7.32.0.tar.gz"
    sha256 "1ca5aadfe27995c879b9253b3a48d1dcc3b1247ea0b5620b087d58f5521be028"

    # Backport support for FFmpeg 8.0
    patch :DATA # https://github.com/mltframework/mlt/commit/604972b255c53927082de3989237f857b7827b74
    patch do
      url "https://github.com/mltframework/mlt/commit/ae83ceee72a0a39c063b02310f6ce928839712a2.patch?full_index=1"
      sha256 "2a3fc8552f068766f1d829aa973e1f913040a83898476c0afd73119e500f2713"
    end
  end

  bottle do
    sha256 arm64_sonoma:  "4b598973ef11d89bb7f97ef4674d1c82d10e795384e31136b335eaee7b5c7988"
    sha256 arm64_ventura: "2b8776a511b6a429588f08937de41284c842803007d7568bdb8f567185619759"
    sha256 sonoma:        "099633d6e641dc539f68946b535d790bcfc6028c4989af49a989f02f2cdc8fb2"
    sha256 ventura:       "296847ba9350fc2166907a045e195ae76afeabf7be88b0405b7740ecb78bba9b"
    sha256 x86_64_linux:  "83f198ba55bd1f942d03dc9956f7a38e210076b9a31184591a87f88790084129"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "sox"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_JACKRACK=OFF",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_QT5=OFF",
                    "-DMOD_QT6=ON",
                    "-DMOD_SDL1=OFF",
                    "-DRELOCATABLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Workaround as current `mlt` doesn't provide an unversioned mlt++.pc file.
    # Remove if mlt readds or all dependents (e.g. `synfig`) support versioned .pc
    (lib/"pkgconfig").install_symlink "mlt++-#{version.major}.pc" => "mlt++.pc"
  end

  test do
    assert_match "help", shell_output("#{bin}/melt -help")
  end
end

__END__
diff --git a/src/modules/avformat/producer_avformat.c b/src/modules/avformat/producer_avformat.c
index 25f81d60e4bc8188c4a537489721ad74aba97431..6984ba286c1141de9bbc21b33e44f5d0ef7fb7dd 100644
--- a/src/modules/avformat/producer_avformat.c
+++ b/src/modules/avformat/producer_avformat.c
@@ -2598,7 +2575,6 @@ static int producer_get_image(mlt_frame frame,
                                             || codec_params->field_order == AV_FIELD_TB;
                 }
                 self->video_frame->top_field_first = self->top_field_first;
-#ifdef AVFILTER
                 if ((self->autorotate || mlt_properties_get(properties, "filtergraph"))
                     && !setup_filters(self) && self->vfilter_graph) {
                     int ret = av_buffersrc_add_frame(self->vfilter_in, self->video_frame);
@@ -2614,7 +2590,7 @@ static int producer_get_image(mlt_frame frame,
                         }
                     }
                 }
-#endif
+
                 set_image_size(self, width, height);
                 if ((image_size
                      = allocate_buffer(frame, codec_params, buffer, *format, *width, *height))) {
