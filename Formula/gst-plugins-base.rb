class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.0.tar.xz"
  sha256 "7e904660ff56e02b036cf7fdfb77a50a540828ca9d2614d69ba931772e5b6940"
  revision 1

  bottle do
    sha256 "93a464d0609c343b1e6522b54e037706802d40d4102af28048060d96d57b9383" => :high_sierra
    sha256 "223bfe1d56a89aedb2262c5d33ae81b3abce83a04f33cc74913ff276fad42117" => :sierra
    sha256 "79481f5fbab1b036519aa6fe816247c07accbcbb6851467fe5d79a2ae91fa61f" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-base.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"

  # The set of optional dependencies is based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-base/tree/REQUIREMENTS
  # and Homebrew formulae
  depends_on "orc" => :recommended
  depends_on "libogg" => :optional
  depends_on "opus" => :optional
  depends_on "pango" => :recommended
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = %W[
      --prefix=#{prefix}
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

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
    output = shell_output("#{gst} --plugin volume")
    assert_match version.to_s, output
  end
end
