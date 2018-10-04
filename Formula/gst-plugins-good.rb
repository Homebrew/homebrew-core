class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.4.tar.xz"
    sha256 "5f8b553260cb0aac56890053d8511db1528d53cae10f0287cfce2cb2acc70979"

    depends_on "check" => :optional
  end

  bottle do
    sha256 "551cf486f1289f1c8a07350cb06b52c7edadba439a9263a907c26a6e21d75139" => :mojave
    sha256 "90a3fc4336e9d7e596f092d3a1d325d8888c6d29ff3988ae7cc44ccac82a5c7e" => :high_sierra
    sha256 "75fe5452ab4ca9570da1e5e4c4fa40b15d7eb43855e2ca0004bc6a72808a57c9" => :sierra
    sha256 "0884f4ff81b994dd98b61ed43b0c9e11d036742bef49ee783b70996f824b5d93" => :el_capitan
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
