class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.16.1.tar.xz"
    sha256 "7f079b9b2a127604b98e297037dc8847ef50f4ce2b508aa2df0cac5b77562899"
  end

  bottle do
    sha256 "adc145563618a2c2e71bc4fb5673431e9fc96a952487c1cc2aec8c70a1890170" => :mojave
    sha256 "f548f74c7824cb1bbc9324f8884a6e257d6c5d4da3cb1bed8291eb4809d10b63" => :high_sierra
    sha256 "bf8c76f74c7c0b447e04efc6d07a068bbf1fc22e34da4b449a3f464336fad706" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      cd "validate" do
        system "./autogen.sh"
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    else
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
