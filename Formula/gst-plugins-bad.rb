class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.14.4.tar.xz"
  sha256 "910b4e0e2e897e8b6d06767af1779d70057c309f67292f485ff988d087aa0de5"

  bottle do
    rebuild 2
    sha256 "056ebc584b99023048ae7e5c93960f17eb78805015f630c772053b490f663b35" => :mojave
    sha256 "3d9c5fb7ce1436970f6bea48a2d5ba016a8a2966a7c2831345de8773cbbaebc1" => :high_sierra
    sha256 "68d084ae8a5ef8d505912a89fd4395925dc7c6b9eb1b53f9eb500ec96b2aabd3" => :sierra
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
  depends_on "openssl"
  depends_on "opus"
  depends_on "orc"
  depends_on "dirac" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "gnutls" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libexif" => :optional
  depends_on "libnice" => :optional
  depends_on "libvo-aacenc" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
  depends_on "srt" => :optional
  depends_on "srtp" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-examples
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

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
