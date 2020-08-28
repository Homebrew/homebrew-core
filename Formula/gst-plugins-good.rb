class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  license "LGPL-2.1"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.16.2.tar.xz"
    sha256 "40bb3bafda25c0b739c8fc36e48380fccf61c4d3f83747e97ac3f9b0171b1319"
  end

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "4ea6d0ea1dcc6c20afbd0976006a84d57067b83926aa74bd28a0d21b4afa1aa9" => :catalina
    sha256 "5bab7c207014dad9b950247148d930251fba89458f97527b9fb076a1a5a843ca" => :mojave
    sha256 "0af59390678c89f8a5c396afcd63e5b1d95d84dad217c61860db6adc3f8c2539" => :high_sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-x
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
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
