class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.16.1.tar.xz"
  sha256 "56481c95339b8985af13bac19b18bc8da7118c2a7d9440ed70e7dcd799c2adb5"

  bottle do
    sha256 "7ce4460d5cc8af2fe5a2ec4193eb7124b545cf33fcb589b63a7c82fecbe0c683" => :mojave
    sha256 "34b6a879aa64a0028c261270927d9f506d6f25698f3d66001702ec0de77c6a62" => :high_sierra
    sha256 "42ef7edf2d9b6b7d9814cab7adfe843fa233541b83467b2c8ccfebf57630aa18" => :sierra
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
