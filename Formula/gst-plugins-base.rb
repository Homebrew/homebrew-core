class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.4.tar.xz"
  sha256 "ca6139490e48863e7706d870ff4e8ac9f417b56f3b9e4b3ce490c13b09a77461"

  bottle do
    sha256 "e9dcf94418b1c531625b9c4b7cb4f19bb68c303960f92d4460df7f1a8114f9e7" => :mojave
    sha256 "5c41c822d4452fb6425120dbfde14cb50330d83ad6538d23cbadf6cb9a01bf89" => :high_sierra
    sha256 "a9135ed9c9a81431434cb6c481d5557537cc2eb52e683b10e41e59db77da21c2" => :sierra
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
  depends_on "pango" => :recommended
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "opus" => :optional
  depends_on "theora" => :optional

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
