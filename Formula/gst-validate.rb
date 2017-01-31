class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.10.3.tar.xz"
  sha256 "be6b48569324c541266310e7e6d1098b1a2ec7cd06b9e95b6701c96bc4562c02"

  bottle do
    sha256 "9276104df63b026d8a682a2e9e5972915d35fae842bbe5f703867ca96465fbea" => :sierra
    sha256 "80b8b5edbd9f49c5f5d4de4efd55d41cdc9468d7bcbf8f39b2bfc8328a848d00" => :el_capitan
    sha256 "5942579c31ed5a0d586e8afeaedff369496dcc3f06ece3e7bf31abdd1cfbbddb" => :yosemite
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
