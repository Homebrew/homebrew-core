class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.10.1.tar.xz"
  sha256 "133e0ed9fe21011b15d3898e3d3a9d17ab74eed31996da2e353353e688ca921d"

  bottle do
    sha256 "21f7a08fab79ad037ab5a7572886adbd86ddc85324605d7d0caf9e624ad849cc" => :sierra
    sha256 "8c1307e517bd2e75d765d4d56108abdade8fe5f06e3172592bc5434eb8159d28" => :el_capitan
    sha256 "b552ab3d3add11d193659658ee41ca60226c913e2bf95f3dd60bdd45c410938e" => :yosemite
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
