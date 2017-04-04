class GstPluginsBadAT010 < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.bz2"
  sha256 "0eae7d1a1357ae8377fded6a1b42e663887beabe0e6cc336e2ef9ada42e11491"
  revision 2

  bottle do
    rebuild 1
    sha256 "81140c3bf87251f58a1394b0a0ce3ad5cf766813ef9f7f35a96dd377d37c3ea9" => :sierra
    sha256 "69aeea1297d3c78858e9dd2a6de786c92fa43ec5a30e4d64fc86c3425b641841" => :el_capitan
    sha256 "dca6d59de707b54eeb09f53f7c40847e118a01364c3a7d887adeda0c2ca85d02" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"
  depends_on "openssl"

  # These optional dependencies are based on the intersection of
  # gst-plugins-bad-0.10.21/REQUIREMENTS and Homebrew formulae
  depends_on "dirac" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libmms" => :recommended

  # These are not mentioned in REQUIREMENTS, but configure look for them
  depends_on "libexif" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :recommended
  depends_on "libsndfile" => :recommended
  depends_on "schroedinger" => :optional
  depends_on "rtmpdump" => :optional

  def install
    ENV.append "CFLAGS", "-no-cpp-precomp -funroll-loops -fstrict-aliasing"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-sdl
      --disable-schemas-compile
    ]

    # Prevent "fatal error: 'QTKit/QTKit.h' file not found"
    if DevelopmentTools.clang_build_version >= 800
      args << "--disable-apple_media"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    gst = Formula["gstreamer@0.10"].opt_bin/"gst-inspect-0.10"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
