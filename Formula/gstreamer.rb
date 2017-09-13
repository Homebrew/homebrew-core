class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.12.2.tar.xz"
  sha256 "9fde3f39a2ea984f9e07ce09250285ce91f6e3619d186889f75b5154ecf994ba"

  bottle do
    sha256 "cfba3e79bfe45cd56494d39bbed0cb00be0866ad3cb3b0c30aa117f5dbe12b9b" => :sierra
    sha256 "edee7984d117c388d531051bfd907535b2825e34d63c56675ba0c994a2696aac" => :el_capitan
    sha256 "d4a99c84b8c34c080a0cca402dac15b1a829e8ab964ff0d03a91af18b394cd1f" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gstreamer.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
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

  test do
    system bin/"gst-inspect-1.0"
  end
end
