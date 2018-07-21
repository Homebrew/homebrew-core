class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.14.2.tar.xz"
  sha256 "ea9e423e5470ef85ef8a0aea1714e7abfc49deb2ed282057367484cdeba6f19f"

  bottle do
    sha256 "42b4292fa742150cd9f27f9fad9bfd3d79011f949fc2ab54f384758302ac74bc" => :high_sierra
    sha256 "f51d4072cf2d18f78eaac88388c248e719d89308c59ad184c233d3b97867b03b" => :sierra
    sha256 "c9776a4326619234c373546a794972f298c885ccbc9cc05b57b6afb6d6d3b626" => :el_capitan
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
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
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
