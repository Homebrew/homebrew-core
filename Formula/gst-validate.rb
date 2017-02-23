class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.10.4.tar.xz"
  sha256 "e59c00bf64cca9c477cdb44eb8dd0b3aac5499b17d77bf28ee054fd211e8d73c"

  bottle do
    sha256 "f0ae20fd85a7ca2a89702c588debe789c87bc723e2d85406da5dfe352df2aae8" => :sierra
    sha256 "e1c419e1519b055b88339ecf25c3ac75b5cb01345f610a7f040970a32dabe009" => :el_capitan
    sha256 "30dddf25e36d5d9eadb1fc234979bddc67a341edb2879e3b9687e8236523ce0e" => :yosemite
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
