class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.1.tar.xz"
  sha256 "28d82b0d261544a9bf85b429399929e4986eb00efcf1ce16cc71d269a4c3186c"

  bottle do
    sha256 "2af22666adee2d820aac856533480addf8dd66df2bf55371c0eee31cf14e783e" => :high_sierra
    sha256 "46baf72db10d85bca89a77a09e6ab1a282567eeda2caf6b668ee5ddd74988f5c" => :sierra
    sha256 "b07be5444e34e6916635c598514ebe5ee4ca11ff29374cdf7614c520bccd678f" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gstreamer.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "bison"

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
