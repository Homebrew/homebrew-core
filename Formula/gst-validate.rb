class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.16.0.tar.xz"
    sha256 "9331ae48a173a048243539730cc7a88607777762dea4aebbc3ab55981e68d6c9"

    patch :p2 do
      url "https://gitlab.freedesktop.org/gstreamer/gst-devtools/commit/751a6d75.diff"
      sha256 "53d3ea9d3167ca6f278046f40dfbf16279df307864d5d37ac4c18a5d7dabbe2e"
    end
  end

  bottle do
    sha256 "4395064df7154ff0b449fa945ca6b4c9cbd396244281fbdcb3690bb2269d8336" => :mojave
    sha256 "eef3a2838bf24464ceae20018adaca5b297d6380974d953effc8e1f3d36dad4b" => :high_sierra
    sha256 "b74fed8b124d45aa4d257f54ea3a1ae38ac892d383f39d4a50ac8c72848c0e7b" => :sierra
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
