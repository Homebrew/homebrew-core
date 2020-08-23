class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.16.2.tar.xz"
  sha256 "f1cb7aa2389569a5343661aae473f0a940a90b872001824bc47fa8072a041e74"
  revision 3

  bottle do
    sha256 "c1031cef7c790bbdf27ffe3eee51ccd128cd28c7309e9da6814ec8cf87682c9d" => :catalina
    sha256 "d390095d1b6cd82eec7c6133fe11c5d944cf63ffe783ce65e7cf0900aedb1100" => :mojave
    sha256 "76524f6b5d72948656e52c06d9dc20b0bb534fe016ee33086aac12ea8d1bbfae" => :high_sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libnice"
  depends_on "libusrsctp"
  depends_on "musepack"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "rtmpdump"
  depends_on "srtp"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-examples
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

    # The apple media plug-in uses API that was added in Mojave
    args << "--disable-apple_media" if MacOS.version <= :high_sierra

    if build.head?
      # autogen is invoked in "stable" build because we patch configure.ac
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
