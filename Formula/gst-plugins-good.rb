class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.3.tar.xz"
    sha256 "5112bce6af0be62760687ca47873c90ce4d65d3fe920a3adf8145db7b07bff5d"

    depends_on "check" => :optional
  end

  bottle do
    sha256 "65d6095b61597becf765646e35d30e0a58293fe2e94ea8f716d20509905e0d57" => :mojave
    sha256 "d9662303e702a1dd2c521ce3b4d0acf85181ec72ffe8e29e97b01ae97af19d5a" => :high_sierra
    sha256 "42582defb0dff9b1d6bdec017f8bfb22440d6fe8f479b2e1736eb8e4b711c043" => :sierra
    sha256 "5c40515683b558638307ea9511b63b86f3970038fd06be9eb21b660eb2a2cff5" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "libsoup"

  # Dependencies based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/REQUIREMENTS
  # and Homebrew formulae.
  depends_on "jpeg" => :recommended
  depends_on "orc" => :recommended
  depends_on "aalib" => :optional
  depends_on "cairo" => :optional
  depends_on "flac" => :optional
  depends_on "gdk-pixbuf" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdv" => :optional
  depends_on "libpng" => :optional
  depends_on "libshout" => :optional
  depends_on "libvpx" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "speex" => :optional
  depends_on "taglib" => :optional
  depends_on :x11 => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--enable-gtk3" if build.with? "gtk+3"

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--disable-x"
    end

    # This plugin causes hangs on Snow Leopard (and possibly other versions?)
    # Upstream says it hasn't "been actively tested in a long time";
    # successor is glimagesink (in gst-plugins-bad).
    # https://bugzilla.gnome.org/show_bug.cgi?id=756918
    args << "--disable-osx_video" if MacOS.version == :snow_leopard

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
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
