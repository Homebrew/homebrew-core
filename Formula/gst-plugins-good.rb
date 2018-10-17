class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.4.tar.xz"
    sha256 "5f8b553260cb0aac56890053d8511db1528d53cae10f0287cfce2cb2acc70979"

    depends_on "check" => :optional
  end

  bottle do
    sha256 "b064a88166dde9a0728e2b4931265c36331fe04763cd86a374f7e871970154b7" => :mojave
    sha256 "4690c041a027f7f8a4d50a50b704bf4474c457bf6d5587d4f6d00b02e0ae9770" => :high_sierra
    sha256 "a992fea0e10e1227d9747bfac9a8df892a63e1e23efe753e65a8e9a93f363c34" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  # Dependencies based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/REQUIREMENTS
  # and Homebrew formulae.
  depends_on "aalib" => :optional
  depends_on "gdk-pixbuf" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdv" => :optional
  depends_on "pulseaudio" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--enable-gtk3" if build.with? "gtk+3"

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--disable-x"
    end

    # This plugin causes hangs on Snow Leopard (and possibly other versions?)
    # Upstream says it hasn't "been actively tested in a long time";
    # successor is glimagesink (in gst-plugins-bad).
    # https://bugzilla.gnome.org/show_bug.cgi?id=756918
    args << "--disable-osx_video" if MacOS.version == :snow_leopard

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
