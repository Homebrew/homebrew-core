class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.16.2.tar.xz"
  sha256 "5500415b865e8b62775d4742cbb9f37146a50caecfc0e7a6fc0160d3c560fbca"
  revision 1

  bottle do
    sha256 "277002faafbb084e673564ff9ef5885e297fdf6bdf465ce64382f75f63ab41ab" => :catalina
    sha256 "62a7e3edeed4b2cb70bfac3af3ae7295352200afbdbc74bf4c99ead28e83f150" => :mojave
    sha256 "89905c00b2ac50f5c1a5a82ecea82917ab91be3b43e7e03f9682ccf0e7eec7ba" => :high_sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --disable-amrnb
      --disable-amrwb
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
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
  end
end
