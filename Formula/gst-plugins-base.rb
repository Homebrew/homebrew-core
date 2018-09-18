class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.3.tar.xz"
  sha256 "f0b319c36be0ffc2a00380c77ba269cdf04e2b39bbc49d30b641fc35aa0b7952"

  bottle do
    sha256 "c2dfcb6a2bb09c3f742f94fbf9dbcd8b8fe65d2dca38419971050e24853f40c2" => :mojave
    sha256 "fdef0c9552decc044c4a962721ce01e8c505680afaed20e2e8bb990e4bf0c813" => :high_sierra
    sha256 "3e42f49c1ff1dda4e10543a8ff39e3bbbf78e936e88bd97cb4e8b59c8e8c3407" => :sierra
    sha256 "2010ec8878a8d84f996d445e13d39bc5b43d1d32b8e7fa56e204f42f1ab5732b" => :el_capitan
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
  depends_on "pango" => :recommended
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "opus" => :optional
  depends_on "theora" => :optional

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
