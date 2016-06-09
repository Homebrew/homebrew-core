class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.8.2.tar.xz"
  sha256 "33c5b585c5ca1659fe6c09fdf02e45d8132c0d386b405bf527b14ab481a0bafe"

  bottle do
    sha256 "bd802200184cdf2716daaad678f5b78dfa87bae2ae274e974bcdd1bbc33fa860" => :el_capitan
    sha256 "95362455a0be1b18017b0b56b5c6ff7a32bbc5cc3e764a60234c04befeeafacc" => :yosemite
    sha256 "a0af3d349a94c26f23cbd8d66b664985f99c14c4445e25e49e18efbdf169a280" => :mavericks
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
