class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.2.tar.xz"
  sha256 "4bd6127299f3f29379046bbd58a526e6353b569e0e72f7b4df2ae70df6882e09"

  bottle do
    sha256 "6a5cd1ad4112ebf5b23409194d000911ddcad3f56b6b4e94f2bd22b108ca8ee9" => :high_sierra
    sha256 "c4eb0ac40a38ea707efd2c5545804b4d8e3fddd99365d918c913d840a74744f2" => :sierra
    sha256 "eccc241d226bba8a357b0f6b8a09850c2ebdafb567ded42267146cdd1da11d50" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gstreamer.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-gtk-doc
      --enable-introspection=yes
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"

      # Ban trying to chown to root.
      # https://bugzilla.gnome.org/show_bug.cgi?id=750367
      args << "--with-ptp-helper-permissions=none"
    end

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Consider also installing gst-plugins-base and gst-plugins-good.

    The gst-plugins-* packages contain gstreamer-video-1.0, gstreamer-audio-1.0,
    and other components needed by most gstreamer applications.
  EOS
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end
