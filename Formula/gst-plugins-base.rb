class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.1.tar.xz"
  sha256 "1026c7c3082d825d9b5d034c1a6dd8a4ebab60eb3738b0a0afde4ad2dc0b0db5"

  bottle do
    sha256 "c4fa697a6454136eee0750940cd868b54e27d2de1163e7e19ae038bb999640e3" => :high_sierra
    sha256 "3dfd7b6db2f6bee06e31295f8ec67bbf321c60a228acae40f8bff237e1a99219" => :sierra
    sha256 "df91b8e4df3d3d01114bd1ccb6869fd7ff2c8fbb5dff058524f5f61cc8cd011d" => :el_capitan
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
