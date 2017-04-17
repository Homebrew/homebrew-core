class GstPluginsBaseAT010 < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.bz2"
  sha256 "2cd3b0fa8e9b595db8f514ef7c2bdbcd639a0d63d154c00f8c9b609321f49976"

  bottle do
    sha256 "5ad2f68ff53c006d92db4543f9ed90dd7cd95ddb48bf99bae2a7718db76bcd91" => :sierra
    sha256 "1c52815b6407f35e967dc7c2c9885f43bd290342f0e16463596a9e57e10f36b6" => :el_capitan
    sha256 "795d24de05759adaf3b54ced0d8aa81f77a8eb8b3652a7c156fa2c5c9b2de7c9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer@0.10"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulae
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
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=no
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
      --disable-gnome_vfs
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer@0.10"].opt_bin/"gst-inspect-0.10"
    output = shell_output("#{gst} --plugin volume")
    assert_match version.to_s, output
  end
end
