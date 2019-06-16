class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.16.0.tar.xz"
    sha256 "9331ae48a173a048243539730cc7a88607777762dea4aebbc3ab55981e68d6c9"

    patch :p2 do
      url "https://gitlab.freedesktop.org/gstreamer/gst-devtools/commit/751a6d75.diff"
      sha256 "53d3ea9d3167ca6f278046f40dfbf16279df307864d5d37ac4c18a5d7dabbe2e"
    end
  end

  bottle do
    rebuild 1
    sha256 "208a1268aefd8a73bc818a238c40621754ee0045b8226659d0988ed40df8b0bf" => :mojave
    sha256 "599800c6c2139bb724b99f93c0c9960bd3de88afc9fbe4f16a76310f719a3379" => :high_sierra
    sha256 "35224cebe6dca83b64dfed37b9968954863255757a3fe5adc2163e551136728e" => :sierra
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
