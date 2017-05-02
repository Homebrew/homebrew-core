class GstPluginsGoodAT010 < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.31.tar.bz2"
  sha256 "7e27840e40a7932ef2dc032d7201f9f41afcaf0b437daf5d1d44dc96d9e35ac6"

  bottle do
    sha256 "34901e80453e914f5b9d0c177676bad5eed5df7f516fbfa4644661937c9dcca1" => :sierra
    sha256 "c83939d0c7e928717ced578b1d406790e3c5d594a727cf8ad16f18fb2ce808a4" => :el_capitan
    sha256 "b62bc4ff67d0f82fc3a6d35b8b525a26d77dd5ccdf8640ac1b1516b64c146bde" => :yosemite
  end

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"
  depends_on "cairo"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-good-0.10.30/REQUIREMENTS and Homebrew formulae
  depends_on "orc" => :optional
  depends_on "gtk+" => :optional
  depends_on "check" => :optional
  depends_on "aalib" => :optional
  depends_on "libcdio" => :optional
  depends_on "flac" => :optional
  depends_on "jpeg" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdv" => :optional
  depends_on "libshout" => :optional
  depends_on "speex" => :optional
  depends_on "taglib" => :optional
  depends_on "libsoup" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-schemas-install
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
    ]

    # Prevent "fatal error: 'QuickTime/QuickTime.h' file not found"
    args << "--disable-osx_video" if DevelopmentTools.clang_build_version >= 800

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer@0.10"].opt_bin/"gst-inspect-0.10"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
