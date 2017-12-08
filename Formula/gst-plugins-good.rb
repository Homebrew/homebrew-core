class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.12.4.tar.xz"
    sha256 "649f49bec60892d47ee6731b92266974c723554da1c6649f21296097715eb957"

    depends_on "check" => :optional
  end

  bottle do
    sha256 "57a5ba70df834a004a14fda8f60c3d2ac60941c2c4be0568971f389f7540e3be" => :high_sierra
    sha256 "ffbb8cda0ae0b6b40f2e8fc72c5e35f2edcd57312482cb03520d75a17934c78b" => :sierra
    sha256 "1ca27cf1d8d5e9ade20a8f1eaecd84cb6b1af06dbb5906bea7e7127ce8618229" => :el_capitan
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

  depends_on :x11 => :optional

  # Dependencies based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/REQUIREMENTS
  # and Homebrew formulae.
  depends_on "jpeg" => :recommended
  depends_on "orc" => :recommended
  depends_on "gdk-pixbuf" => :optional
  depends_on "aalib" => :optional
  depends_on "cairo" => :optional
  depends_on "flac" => [:optional, "with-libogg"]
  depends_on "libcaca" => :optional
  depends_on "libdv" => :optional
  depends_on "libpng" => :optional
  depends_on "libshout" => :optional
  depends_on "speex" => :optional
  depends_on "taglib" => :optional

  depends_on "libvpx" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "jack" => :optional

  depends_on "libogg" if build.with? "flac"

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
