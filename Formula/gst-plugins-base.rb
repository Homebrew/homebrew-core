class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.16.1.tar.xz"
  sha256 "5c3cc489933d0597087c9bc6ba251c93693d64554bcc563539a084fa2d5fcb2b"

  bottle do
    sha256 "54ab689dd69b17d4dc78f98b8e36b44d65df8310500f9461feab5522504ebce8" => :catalina
    sha256 "4acaaf10a1174a9b4339653683a17601dbaa7be69e379680fc51650e64c3b19b" => :mojave
    sha256 "1a0f81a6161550b42e7bbd349eee7accb5b5e489f6b24756ff7d2847bd8eaafc" => :high_sierra
    sha256 "3adaa7060d255bf9198db9c72894d605eca6f15507e1b725c8f53637cb93a702" => :sierra
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
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "orc"
  depends_on "pango"
  depends_on "theora"

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
