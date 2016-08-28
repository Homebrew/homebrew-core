class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.3.tar.xz"
    sha256 "7899fcb18e6a1af2888b19c90213af018a57d741c6e72ec56b133bc73ec8509b"
  end

  bottle do
    sha256 "ac06d0d507132e957db67ab70e695ca217dadb58fae6eac7898b524f3274fa8f" => :el_capitan
    sha256 "56ee0524b92692aa9f22f56942b9d29ce17e5ef472e41993d4cb21a370f47006" => :yosemite
    sha256 "ea2b3e801bf9ab667af73c6cb2bd03c9f52bf95b8ff991335f6ecfb9baad3609" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "openssl"

  depends_on "orc" => :recommended
  depends_on "dirac" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "gnutls" => :optional
  depends_on "gtk+3" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libexif" => :optional
  depends_on "libmms" => :optional
  depends_on "homebrew/science/opencv" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
  depends_on "srtp" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-sdl
      --disable-debug
      --disable-dependency-tracking
    ]

    # upstream does not support Apple video for older SDKs
    # error: use of undeclared identifier 'AVQueuedSampleBufferRenderingStatusFailed'
    # https://github.com/Homebrew/legacy-homebrew/pull/35284
    if MacOS.version <= :mavericks
      args << "--disable-apple_media"
    end

    args << "--with-gtk=3.0" if build.with? "gtk+3"

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
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
