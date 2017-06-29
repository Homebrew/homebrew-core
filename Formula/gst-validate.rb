class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.12.0.tar.xz"
  sha256 "73efaf123638b97159c1ff6575dd05ea0cf7dc6d71b07806b5a5f25188a67fbb"

  bottle do
    sha256 "af36f83634e0c990402dbc1296128f7cfdc74b46c8080fc2d46c7101d6ec6ee3" => :sierra
    sha256 "4f8625dd089a813ec902d86d7a930259def088ec88bd2b890dd867fc3f5cf385" => :el_capitan
    sha256 "e289b310064827a187c1af49541c7bc5f60b2deeddeea1edee267f9fa95c00d1" => :yosemite
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
  depends_on "json-glib"

  def install
    inreplace "tools/gst-validate-launcher.in", "env python3", "env python"

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
