class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.2.tar.xz"
    sha256 "d7995317530c8773ec088f94d9320909d41da61996b801ebacce9a56af493f97"

    # corevideomemory.h and iosurfacememory.h are missing from the tarball
    # should be removed after >1.8.2 is released
    # https://bugzilla.gnome.org/show_bug.cgi?id=766163
    # https://github.com/GStreamer/gst-plugins-bad/commit/43487482e5c5ec71867acb887d50b8c3f813cd63
    resource "corevideomemory_header" do
      url "https://raw.githubusercontent.com/GStreamer/gst-plugins-bad/1.8.2/sys/applemedia/corevideomemory.h"
      sha256 "9d8c0fc6b310cb510a2af93a7614db80ec272ebd3dd943ecd47e65130b43aeea"
    end

    # same as above
    # should be removed after >1.8.2 is released
    resource "iosurfacememory_header" do
      url "https://raw.githubusercontent.com/GStreamer/gst-plugins-bad/1.8.2/sys/applemedia/iosurfacememory.h"
      sha256 "c617ff11e5abd8d71e97afe33d8e573685ab209a1a22184d56ad2cdb916d826c"
    end
  end

  bottle do
    sha256 "ac772511bc495fc4ca417318becc6bf7c2069f52ae87ea49f0afb0ada6f3d5e6" => :el_capitan
    sha256 "e3e245e57f0ff017606781b90b1a603d5b3a04b961bd93ef6303106bad528453" => :yosemite
    sha256 "22543bf30f8f003dba42bfec05792885454925af3131034c64e98bf6671bc7c6" => :mavericks
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
    elsif !build.head?
      # should be removed after >1.8.2 is released
      resource("corevideomemory_header").stage buildpath/"sys/applemedia"
      resource("iosurfacememory_header").stage buildpath/"sys/applemedia"
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
