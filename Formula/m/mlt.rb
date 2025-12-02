class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1-only"
  revision 4
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
    sha256 arm64_tahoe:   "22a8292716eb5104a09b7a55e40fad6b0a30417bbc1df32c7b5fbf8c9e1aef3d"
    sha256 arm64_sequoia: "af25732dc924762956280f5a8126a6582db616317d7c18c8086e7d80a2f881e5"
    sha256 arm64_sonoma:  "ea71492bcb2a5297fe5a8061b5fba2d7176b4daafa17d6e0bfd74de463c83f82"
    sha256 sonoma:        "dff42b3a260f17aff918ec45da4813f6e77bea4e8937ad8f8b1147ba135db6ff"
    sha256 arm64_linux:   "26f3e2daf30fa5e45a08a2de948d41e3bea526f5e8438ce568e140f8114ead00"
    sha256 x86_64_linux:  "0931d5ab6fe3bd86afd464fb845d4e1e88b0582d35208220c5659982ab645a69"
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
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
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
