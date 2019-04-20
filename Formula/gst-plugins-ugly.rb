class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.16.0.tar.xz"
  sha256 "e30964c5f031c32289e0b25e176c3c95a5737f2052dfc81d0f7427ef0233a4c2"

  bottle do
    rebuild 1
    sha256 "621b63833b6f427f43d10a23479633c41be26cea3b0c010e16edb8dac6952cdc" => :mojave
    sha256 "84aa90609c55698ae1e4074c5b55a67d1a8f23f0ee1635bdbd3323a04c129804" => :high_sierra
    sha256 "6c9a0035be9cfd26a24b6ec167ade6a2c5f7d5c9054dfec4703b1efdd79e669d" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libmms"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --disable-amrnb
      --disable-amrwb
    ]

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
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
  end
end
