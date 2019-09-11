class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.16.0.tar.xz"
  sha256 "4093aa7b51e28fb24dfd603893fead8d1b7782f088b05ed0f22a21ef176fb5ae"
  revision 1

  bottle do
    sha256 "c5e6da8ef2c6e81c77b7fe59d35b78819dc079d8e14ded2dfe698b4c7ad2163b" => :mojave
    sha256 "4ca45057ad13cf6190adce18eb437fba929f2f83a2550fad485b360fba80a637" => :high_sierra
    sha256 "ba185f1a63a7e787589cfb8a0eaef7ffb2c638e1fe5f0ef0800a52c75b75b48e" => :sierra
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
