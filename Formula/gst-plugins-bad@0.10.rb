class GstPluginsBadAT010 < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.bz2"
  sha256 "0eae7d1a1357ae8377fded6a1b42e663887beabe0e6cc336e2ef9ada42e11491"
  revision 2

  bottle do
    sha256 "5b2ee005df419f9b9397fd5b618f4a97f0d2b1af60404b5cc7d15f3c7d02c243" => :sierra
    sha256 "51c6fccf38e4825c1615207c7290c5a7712cbc68282914a3966589e663f1e6fc" => :el_capitan
    sha256 "5d8685e6aea37bad4a76b40dfff1772daf53289e3b985e43251022d0c70b2ca8" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"
  depends_on "openssl"

  # These optional dependencies are based on the intersection of
  # gst-plugins-bad-0.10.21/REQUIREMENTS and Homebrew formulae
  depends_on "dirac" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libmms" => :optional

  # These are not mentioned in REQUIREMENTS, but configure look for them
  depends_on "libexif" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "libsndfile" => :optional
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
