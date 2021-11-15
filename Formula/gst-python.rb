class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.18.4.tar.xz"
  sha256 "cb68e08a7e825e08b83a12a22dcd6e4f1b328a7b02a7ac84f42f68f4ddc7098e"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-python/"
    regex(/href=.*?gst-python[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b4ec598c3bd3e35757da9d86c2b8cb42aa24b08226b15c1d37ab4abc77cfc73f"
    sha256 arm64_big_sur:  "0141e26cbdf16eab9c46ca9fd95aaa31f1311297d627f18cf677d5440c9a1186"
    sha256 monterey:       "53f99452f853e91551a9775300e1ddc667e6ae10eb3b00a15160e2305e89e0b0"
    sha256 big_sur:        "c5461f496775e0d65ed07bb217d1f12eb68ba633ea9c688add6297fab942fdd6"
    sha256 catalina:       "7de5518b76bea95a7769f1230db57fa03d389483f7800e060db7f2553ac0f856"
    sha256 mojave:         "c155c0ff5e23c12f99746fd05058bfc5d01f4b3af9f2abf641035f7564efef1d"
    sha256 x86_64_linux:   "081e9a6f6681bca1cc7f029cc483aa6821bfebe512af9046c8ac34a9c742ff5d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gst-plugins-base"
  depends_on "pygobject3"
  depends_on "python@3.9"

  # See https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gst-python/-/commit/3e752ede7ed6261681ef3831bc3dbb594f189e76.diff"
    sha256 "d6522bb29f1894d3d426ee6c262a18669b0759bd084a6d2a2ea1ba0612a80068"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end
