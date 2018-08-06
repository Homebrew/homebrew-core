class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.14.2.tar.xz"
  sha256 "ea9e423e5470ef85ef8a0aea1714e7abfc49deb2ed282057367484cdeba6f19f"

  bottle do
    sha256 "187bcb4fc5ce37e413db4b359d6bf9afb6a7b229f70af1b383d56ab230b74577" => :high_sierra
    sha256 "82c72efbf1d119c1353a31d19e5ee90f3925793fcb8483c89629386988aeb574" => :sierra
    sha256 "ffa2a301e0b0dc61fe672b014cf69d20375d1ee54f13d9429fd89c32ef301ce1" => :el_capitan
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
