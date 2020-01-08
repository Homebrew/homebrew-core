class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.16.2.tar.xz"
    sha256 "4861ccb9326200e74d98007e316b387d48dd49f072e0b78cb9d3303fdecfeeca"
  end

  bottle do
    sha256 "1d1b40183962c3ff22122b708b33dfa1d640ac75c48b6dda784b5bbd3eaed7bc" => :catalina
    sha256 "0de1ceef0e0ee0f07a27e01a010094935288f00e890df1cc49159519741ce3c9" => :mojave
    sha256 "d8f1cd16776e2a3b5754513a5b60f7313f29465a90153043e489b1d37497a105" => :high_sierra
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
