class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.12.1.tar.xz"
  sha256 "7def8049d1c44e50199023159dfada60af58fd503ef58a020b79044bda705b97"

  bottle do
    sha256 "b4b1a648677cae5e21bf3ebac04601ec9f3ea8c6fcd3b39b85ae17e8d2876558" => :sierra
    sha256 "7482dfde8a60574ece43e2fe5a347e43f495c8519c0852a27e62f76c423caf75" => :el_capitan
    sha256 "92221b1c4e807c995539ebf5fd8162afbfbe92f78ded0ae74015fe30ca2fc0c8" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "openssl"
  depends_on "jpeg" => :recommended
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
  depends_on "libvo-aacenc" => :optional

  # gst-libs/gst/gl/cocoa/gstglwindow_cocoa.h is missing in the 1.12.1 release. Fixed by this commit:
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-bad/commit/?id=450b1c92abe2ae8f84e557f61c9512a1f4006bab
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4fba405/gst-plugins-bad/gstglwindow_cocoa.patch"
    sha256 "fb6ee96a8c33bcf182ffd22b025bbc652d0225e87bceb9f24793ae9e520fa2cd"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-sdl
      --disable-debug
      --disable-dependency-tracking
    ]

    args << "--with-gtk=3.0" if build.with? "gtk+3"

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
