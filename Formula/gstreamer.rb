class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.4.tar.xz"
  sha256 "f94f6696c5f05a3b3a9183e39c5f5c0b779f75a04c0efa497e7920afa985ffc7"

  bottle do
    sha256 "183a2f8b122d6503bf02c658ebef1124b2bbbec92fbca347542fb8b4caa86371" => :mojave
    sha256 "2ffa21e99a9a42494c32aad1229f90f021dcaf47bd3a63ecea2f66870b7b7a28" => :high_sierra
    sha256 "78e14bb05787978452d0f793583dbf356865d4761d57868821e2e20d6150db93" => :sierra
    sha256 "d98d9db9fe7d4814f2fad5aa96164fc24aed922eb75cc904647d36ab2aa47f1e" => :el_capitan
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
