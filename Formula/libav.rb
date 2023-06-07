class Libav < Formula
  desc "Audio and video processing tools"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.xz"
  sha256 "6893cdbd7bc4b62f5d8fd6593c8e0a62babb53e323fbc7124db3658d04ab443b"
  license "GPL-2.0-or-later"
  revision 8
  head "https://git.libav.org/libav.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d163d72bbc94cf659325285190fbbf60f8e3232bb60eba917c57bb3fa4189983"
    sha256 cellar: :any,                 arm64_big_sur:  "0654bef05e6d8a3fa7fbeb6e9be5a02abe411ebbb3eec69c7a2e1f4b309cb6f5"
    sha256 cellar: :any,                 monterey:       "6db33d4e93ba3b0cb88b1474eadaabe505a3333501b56366e2b95813c8021231"
    sha256 cellar: :any,                 big_sur:        "0bd97c8c39f11b5b29d5c271a28eb4ea4a40b4062a4331f8d97f738c9a82fb05"
    sha256 cellar: :any,                 catalina:       "fcfafef0bb5eeee417c1d69d8ddb1fe0d7a8f8fe70edf39b8499a0df841f6905"
    sha256 cellar: :any,                 mojave:         "f71b7acc7dd972d60176b7d6c9bfe247181867d98ff991d771dcff54a6beace5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ddcdad67f78046192ba87f2cdb2012b886e714b08f7595133f348e5761bd6fa"
  end

  # See: https://lists.libav.org/pipermail/libav-devel/2020-April/086589.html
  disable! date: "2022-07-31", because: :unmaintained

  depends_on "pkg-config" => :build
  # manpages won't be built without texi2html
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "faac"
  depends_on "fdk-aac"
  depends_on "freetype"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "sdl12-compat"
  depends_on "theora"
  depends_on "x264"
  depends_on "xvid"

  # Cherry-picked hunk from https://github.com/libav/libav/commit/fe7bc1f16abaefe66d8a20f734ca3eb8a4ce4d43
  # (second hunk in above commit conflicts with released source)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e07f287/libav/remove_unconditional_X11_probe.patch"
    sha256 "093364c5cb0d79fb80566b5b466e6e8877d01c70e32b6f8ad624205005caba26"
  end

  # https://bugzilla.libav.org/show_bug.cgi?id=1033
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b6e917c/libav/Check-for--no_weak_imports-in-ldflags-on-macOS.patch"
    sha256 "986d748ba2c7c83319a59d76fbb0dca22dcd51f0252b3d1f3b80dbda2cf79742"
  end

  # Upstream patch for x264 version >= 153, should be included in libav > 12.3
  patch do
    url "https://github.com/libav/libav/commit/c6558e8840fbb2386bf8742e4d68dd6e067d262e.patch?full_index=1"
    sha256 "0fcfe69274cccbca33825414f526300a1fbbf0c464ac32577e1cc137b8618820"
  end

  # Upstream patch to fix building with fdk-aac 2
  patch do
    url "https://github.com/libav/libav/commit/141c960e21d2860e354f9b90df136184dd00a9a8.patch?full_index=1"
    sha256 "7081183fed875f71d53cce1e71f6b58fb5d5eee9f30462d35f9367ec2210507b"
  end

  # Fix for image formats removed from libvpx
  # https://github.com/shirkdog/hardenedbsd-ports/blob/HEAD/multimedia/libav/files/patch-libavcodec_libvpx.c
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-shared
      --disable-indev=jack
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gpl
      --enable-libfaac
      --enable-libfdk-aac
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libxvid
      --enable-nonfree
      --enable-vda
      --enable-version3
      --enable-libtheora
      --disable-libxcb
      --disable-vaapi
      --disable-vdpau
    ]

    system "./configure", *args
    system "make"

    bin.install "avconv", "avprobe", "avplay"
    man1.install "doc/avconv.1", "doc/avprobe.1", "doc/avplay.1"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"avconv", "-y", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end

__END__
--- a/libavcodec/libvpx.c
+++ b/libavcodec/libvpx.c
@@ -25,6 +25,7 @@
 enum AVPixelFormat ff_vpx_imgfmt_to_pixfmt(vpx_img_fmt_t img)
 {
     switch (img) {
+#if VPX_IMAGE_ABI_VERSION < 5
     case VPX_IMG_FMT_RGB24:     return AV_PIX_FMT_RGB24;
     case VPX_IMG_FMT_RGB565:    return AV_PIX_FMT_RGB565BE;
     case VPX_IMG_FMT_RGB555:    return AV_PIX_FMT_RGB555BE;
@@ -36,10 +37,13 @@ enum AVPixelFormat ff_vpx_imgfmt_to_pixfmt(vpx_img_fmt
     case VPX_IMG_FMT_ARGB_LE:   return AV_PIX_FMT_BGRA;
     case VPX_IMG_FMT_RGB565_LE: return AV_PIX_FMT_RGB565LE;
     case VPX_IMG_FMT_RGB555_LE: return AV_PIX_FMT_RGB555LE;
+#endif
     case VPX_IMG_FMT_I420:      return AV_PIX_FMT_YUV420P;
     case VPX_IMG_FMT_I422:      return AV_PIX_FMT_YUV422P;
     case VPX_IMG_FMT_I444:      return AV_PIX_FMT_YUV444P;
+#if VPX_IMAGE_ABI_VERSION < 5
     case VPX_IMG_FMT_444A:      return AV_PIX_FMT_YUVA444P;
+#endif
 #if VPX_IMAGE_ABI_VERSION >= 3
     case VPX_IMG_FMT_I440:      return AV_PIX_FMT_YUV440P;
     case VPX_IMG_FMT_I42016:    return AV_PIX_FMT_YUV420P16BE;
@@ -53,6 +57,7 @@ enum AVPixelFormat ff_vpx_imgfmt_to_pixfmt(vpx_img_fmt
 vpx_img_fmt_t ff_vpx_pixfmt_to_imgfmt(enum AVPixelFormat pix)
 {
     switch (pix) {
+#if VPX_IMAGE_ABI_VERSION < 5
     case AV_PIX_FMT_RGB24:        return VPX_IMG_FMT_RGB24;
     case AV_PIX_FMT_RGB565BE:     return VPX_IMG_FMT_RGB565;
     case AV_PIX_FMT_RGB555BE:     return VPX_IMG_FMT_RGB555;
@@ -64,10 +69,13 @@ vpx_img_fmt_t ff_vpx_pixfmt_to_imgfmt(enum AVPixelForm
     case AV_PIX_FMT_BGRA:         return VPX_IMG_FMT_ARGB_LE;
     case AV_PIX_FMT_RGB565LE:     return VPX_IMG_FMT_RGB565_LE;
     case AV_PIX_FMT_RGB555LE:     return VPX_IMG_FMT_RGB555_LE;
+#endif
     case AV_PIX_FMT_YUV420P:      return VPX_IMG_FMT_I420;
     case AV_PIX_FMT_YUV422P:      return VPX_IMG_FMT_I422;
     case AV_PIX_FMT_YUV444P:      return VPX_IMG_FMT_I444;
+#if VPX_IMAGE_ABI_VERSION < 5
     case AV_PIX_FMT_YUVA444P:     return VPX_IMG_FMT_444A;
+#endif
 #if VPX_IMAGE_ABI_VERSION >= 3
     case AV_PIX_FMT_YUV440P:      return VPX_IMG_FMT_I440;
     case AV_PIX_FMT_YUV420P16BE:  return VPX_IMG_FMT_I42016;
