class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.14.4.tar.xz"
  sha256 "ca6139490e48863e7706d870ff4e8ac9f417b56f3b9e4b3ce490c13b09a77461"

  bottle do
    sha256 "2f1cadc4ce245d38e40bd32b4d7accda27b0a5600e99010ab56bf85b0706eb02" => :mojave
    sha256 "b78e0a7b3fd607ba88532f69d901c4c679616fb3584875b6a96fa43398a5d7b0" => :high_sierra
    sha256 "62e973900f80fae593237928393ba3e45b998ca7fcba48db9892c7a0bd556ece" => :sierra
    sha256 "68fef22549f02126073d986c7bca1e164c40857a0aa0f2d6725dca499e355ded" => :el_capitan
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
