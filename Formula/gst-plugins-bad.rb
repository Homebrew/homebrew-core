class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.12.2.tar.xz"
  sha256 "9c2c7edde4f59d74eb414e0701c55131f562e5c605a3ce9b091754f106c09e37"
  revision 1

  bottle do
    sha256 "882d05c4bceba8c66b28ee1336d3800d2247a91ecbbdb7ef92dac750b161dcf5" => :sierra
    sha256 "f284ee2c2671d23d85d7583b2409c42b0b37fe9137c56e44802384272056c3da" => :el_capitan
    sha256 "2977e89ca6a6de84d1270d12a3fde22143870621a7f9d0b26b2d32c092bf62ad" => :yosemite
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
  depends_on "fdk-aac" => :optional
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
  depends_on "srtp@1.5" => :optional
  depends_on "libvo-aacenc" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-examples
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
