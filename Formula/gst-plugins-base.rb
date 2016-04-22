class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.8.1.tar.xz"
  sha256 "15a9de985cd265c344e359f5b19347df4021b7611ed2c2d91917cb900f2fad6f"

  bottle do
    sha256 "ad7d6fc9e1a6f1f8128782321f82b82f77fb94d160cd8d753e84d7aa2c6ae5d7" => :el_capitan
    sha256 "b87d37536843f419ce9ecd7d5d6f4170217f78e8d4c9665c0f2967be047f9d00" => :yosemite
    sha256 "dd1cfeb994248015d9bdefe34f623ee2fc9166df60d24812e824c44b1cc27e51" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-base.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulae
  depends_on "gobject-introspection"
  depends_on "orc" => :optional
  depends_on "gtk+" => :optional
  depends_on "libogg" => :optional
  depends_on "pango" => :optional
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
