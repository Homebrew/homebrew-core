class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.10.0.tar.xz"
  sha256 "bfcdef97dfc69a0bbdb4403c47aae4e53def176bf0b781c5d818550536cfe94a"

  bottle do
    sha256 "fda5d811348648e9da0549ef8afddc40c4ad15077245426e939cb4bca9066c0f" => :sierra
    sha256 "4a4de2e2f648343c0c7d52a1067c5f77cbff8bc614ac54bbc75e511880c3b065" => :el_capitan
    sha256 "fd2dbe0008b7e7e7a48ab683c0a20afd7a21fd641a65453192301c2780af0bc7" => :yosemite
    sha256 "53d8b7a043a54481e11f3b1f1613948431ff49e2a91b793e7d9675b14d5fa463" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-base.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"

  # The set of optional dependencies is based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-base/tree/REQUIREMENTS
  # and Homebrew formulae
  depends_on "gobject-introspection"
  depends_on "orc" => :recommended
  depends_on "libogg" => :optional
  depends_on "opus" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional

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
