class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.8.1.tar.xz"
  sha256 "a9b208c014cca2dc515599f01fd3a7a294133fd936366e74f439b9bc96a1ccbf"

  bottle do
    sha256 "ed59fc8ba0c857f6b3f275737ad073ab98346e81a1f178f5777ff7a3985cf063" => :el_capitan
    sha256 "e8f3aaf0af57de6ed06b19270d0018c5941852bd147d0eb64849a60843bf699b" => :yosemite
    sha256 "cb61b41c0f50e1369e6f982ca726b89ab849b436c4c3fd2effc3d24a50e0e7f1" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    inreplace "tools/gst-validate-launcher.in", "env python2", "env python"

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
