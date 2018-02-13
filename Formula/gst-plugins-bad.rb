class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.12.4.tar.xz"
    sha256 "0c7857be16686d5c1ba6e34bd338664d3d4599d32714a8eca5c8a41a101e2d08"

    # This patch allows video player applications to update the video frame
    # rectangle used for rendering on widgets.
    # Date: Tue, 26 Dec 2017 13:23:11 +0000
    # Subject: [PATCH] gl: cocoa: Implement set_render_rectangle
    # Commited in gst-plugins-base which is the new location of the GstGL library.
    # Please remove this patch for the first 1.14 release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/5f5b837/gst-plugins-bad/0001-gl-cocoa-Implement-set_render_rectangle.patch"
      sha256 "afa4d6948f70426173b82f49daca2ebb5fb350b1cd7c969e7a0d3f94fe794b08"
    end
  end

  bottle do
    sha256 "bcdea83de3821af70a5ba97e08f83c615bf21ceabadf5c5a6f0ec512085039c3" => :high_sierra
    sha256 "58dffc38df2d23652ed04e14ea29b1478c9005d74718358447579f8b7433186d" => :sierra
    sha256 "8b8e5a67171f0d741f8a8ebe55c8f3a1df725bfdd4a18cbfd43baada1901633a" => :el_capitan
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
  depends_on "opencv@2" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
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
